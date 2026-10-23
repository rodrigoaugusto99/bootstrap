import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/exceptions/app_error.dart';
import 'package:bootstrap/firestore/entitlements.dart';
import 'package:bootstrap/services/api_service.dart';
import 'package:bootstrap/utils/constants.dart';
import 'package:bootstrap/utils/formatters.dart';
import 'package:bootstrap/utils/purchase_constants.dart';
import 'package:bootstrap/utils/purchase_enums.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:intl/intl.dart';

class PlanOffer {
  const PlanOffer({
    required this.plan,
    required this.productId,
    required this.price,
    required this.priceValue,
    required this.currencyCode,
    required this.hasTrial,
    required this.details,
  });

  final PurchasePlan plan;
  final String productId;
  final String price;
  final double priceValue;
  final String currencyCode;
  final bool hasTrial;
  final ProductDetails details;

  String? get monthlyEquivalent =>
      plan == PurchasePlan.annual && currencyCode == 'BRL'
          ? NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
              .format(priceValue / 12)
          : null;
}

// Compra pela loja, validação pelo backend. A transação só é finalizada na loja
// (completePurchase) DEPOIS que o /purchases/validate responde OK: se a chamada
// falhar, a loja reentrega na próxima abertura e nenhuma compra fica sem dono.
class PurchaseService {
  final _log = getLogger('PurchaseService');
  final _api = locator<ApiService>();
  final _firestore = EntitlementsFirestore();

  final ValueNotifier<Map<PurchasePlan, PlanOffer>> offers =
      ValueNotifier(const {});
  final ValueNotifier<bool> storeAvailable = ValueNotifier(false);
  final ValueNotifier<PurchaseFlowState> flow =
      ValueNotifier(PurchaseFlowState.idle);
  final ValueNotifier<String?> lastMessage = ValueNotifier(null);

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  Timer? _restoreTimeout;
  bool _restoredSomething = false;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  Future<void> init() async {
    flow.addListener(() => _log.i('fluxo de compra: ${flow.value.name}'
        '${lastMessage.value == null ? '' : ' (${lastMessage.value})'}'));
    _subscription ??= InAppPurchase.instance.purchaseStream.listen(
      _onPurchases,
      onError: (Object e) => _log.e('purchaseStream: $e'),
    );
    await loadOffers();
  }

  Future<void> loadOffers() async {
    try {
      storeAvailable.value = await InAppPurchase.instance.isAvailable();
      if (!storeAvailable.value) {
        _log.w('Loja indisponível neste aparelho');
        return;
      }
      final response = await InAppPurchase.instance
          .queryProductDetails(subscriptionProductIds);
      if (response.notFoundIDs.isNotEmpty) {
        _log.w('Produtos não encontrados na loja: ${response.notFoundIDs}');
      }
      offers.value = Platform.isAndroid
          ? _androidOffers(response.productDetails)
          : await _iosOffers(response.productDetails);
      _log.i(
          'Ofertas da loja: ${offers.value.values.map((o) => '${o.productId} '
              '${o.price} teste=${o.hasTrial}').join('; ')}');
    } catch (e) {
      _log.w('Não carregou os preços da loja: $e');
    }
  }

  PurchasePlan _planOf(String productId) =>
      productId == productAnnual ? PurchasePlan.annual : PurchasePlan.monthly;

  // iOS: o teste grátis só aparece se a pessoa ainda pode usar a oferta de teste.
  Future<Map<PurchasePlan, PlanOffer>> _iosOffers(
      List<ProductDetails> products) async {
    final result = <PurchasePlan, PlanOffer>{};
    final platform = InAppPurchasePlatform.instance;
    for (final product in products) {
      var eligible = false;
      if (platform is InAppPurchaseStoreKitPlatform) {
        try {
          eligible = await platform.isIntroductoryOfferEligible(product.id);
        } catch (e) {
          _log.w('Elegibilidade do teste (${product.id}): $e');
        }
      }
      final plan = _planOf(product.id);
      result[plan] = PlanOffer(
        plan: plan,
        productId: product.id,
        price: product.price,
        priceValue: product.rawPrice,
        currencyCode: product.currencyCode,
        hasTrial: plan == PurchasePlan.annual && eligible,
        details: product,
      );
    }
    return result;
  }

  // Android: o Google só devolve as ofertas para as quais a conta é elegível. A oferta
  // de teste tem uma fase de preço zero; o preço cobrado é o da última fase.
  Map<PurchasePlan, PlanOffer> _androidOffers(List<ProductDetails> products) {
    final result = <PurchasePlan, PlanOffer>{};
    for (final product in products.whereType<GooglePlayProductDetails>()) {
      final index = product.subscriptionIndex;
      final offerDetails = index == null
          ? null
          : product.productDetails.subscriptionOfferDetails?[index];
      if (offerDetails == null) continue;
      final phases = offerDetails.pricingPhases;
      final trial = phases.any((p) => p.priceAmountMicros == 0);
      final recurring = phases.last;
      final plan = _planOf(product.id);
      final current = result[plan];
      if (current != null && (current.hasTrial || !trial)) continue;
      result[plan] = PlanOffer(
        plan: plan,
        productId: product.id,
        price: recurring.formattedPrice,
        priceValue: recurring.priceAmountMicros / 1000000,
        currencyCode: recurring.priceCurrencyCode,
        hasTrial: plan == PurchasePlan.annual && trial,
        details: product,
      );
    }
    return result;
  }

  Future<void> buy(PurchasePlan plan) async {
    final offer = offers.value[plan];
    final uid = _uid;
    if (offer == null || uid == null) {
      throw AppError(
          message: 'A loja não está disponível agora. Tente de novo.');
    }
    lastMessage.value = null;
    _log.i(
        'comprar ${offer.productId} (${offer.price}, teste=${offer.hasTrial}) '
        'uid $uid');
    flow.value = PurchaseFlowState.purchasing;
    final PurchaseParam param;
    if (Platform.isAndroid) {
      param = GooglePlayPurchaseParam(
        productDetails: offer.details,
        applicationUserName: obfuscatedAccountId(uid),
      );
    } else {
      final String token;
      try {
        token = await _firestore.getOrCreateAppAccountToken(uid);
      } catch (e) {
        _log.e('comprar: sem appAccountToken (users/$uid): $e');
        flow.value = PurchaseFlowState.idle;
        throw AppError(message: 'Sem conexão agora. Tente de novo.');
      }
      param = PurchaseParam(
          productDetails: offer.details, applicationUserName: token);
    }
    try {
      await InAppPurchase.instance.buyNonConsumable(purchaseParam: param);
    } catch (e, s) {
      flow.value = PurchaseFlowState.idle;
      _log.e('buy: $e\n$s');
      throw AppError(message: 'Não foi possível abrir a compra agora.');
    }
  }

  // O Google pede um hash, não o id da conta.
  static String obfuscatedAccountId(String uid) =>
      sha256.convert(utf8.encode(uid)).toString();

  Future<void> restore() async {
    lastMessage.value = null;
    _log.i('restaurar compras, uid $_uid');
    flow.value = PurchaseFlowState.restoring;
    _restoredSomething = false;
    await InAppPurchase.instance.restorePurchases();
    _restoreTimeout?.cancel();
    _restoreTimeout = Timer(const Duration(seconds: 12), () {
      if (flow.value == PurchaseFlowState.restoring && !_restoredSomething) {
        _log.w('restaurar: a loja não devolveu nenhuma assinatura em 12s');
        lastMessage.value =
            'Não encontramos uma assinatura nesta conta da loja.';
        flow.value = PurchaseFlowState.error;
      }
    });
  }

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      _log.i('loja: ${purchase.productID} ${purchase.status.name} '
          'id ${purchase.purchaseID} data ${purchase.transactionDate} '
          'pendente de finalizar=${purchase.pendingCompletePurchase}');
      switch (purchase.status) {
        case PurchaseStatus.pending:
          flow.value = PurchaseFlowState.purchasing;
        case PurchaseStatus.canceled:
          flow.value = PurchaseFlowState.idle;
        case PurchaseStatus.error:
          _log.e('Compra com erro: ${purchase.error?.code} '
              '${purchase.error?.message} ${purchase.error?.details}');
          lastMessage.value = 'A compra não foi concluída.';
          flow.value = PurchaseFlowState.error;
          if (purchase.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(purchase);
          }
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (!subscriptionProductIds.contains(purchase.productID)) continue;
          _restoredSomething = true;
          await _deliver(purchase);
      }
    }
  }

  Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body) =>
      _api.request(
        url: '$apiUrl$path',
        method: HttpMethod.POST,
        body: body,
        needAuthenticate: true,
      );

  Future<void> _deliver(PurchaseDetails purchase) async {
    final restored = purchase.status == PurchaseStatus.restored;
    // A loja reentrega sozinha, ao abrir o app, transações que ficaram sem finalizar.
    // Essas entregas não foram pedidas por nenhuma tela e não podem virar erro na tela
    // de quem, por acaso, está comprando ou restaurando naquele momento.
    final requested = flow.value ==
        (restored ? PurchaseFlowState.restoring : PurchaseFlowState.purchasing);
    final body = Platform.isAndroid
        ? {
            'platform': 'android',
            'purchaseToken': purchase.verificationData.serverVerificationData,
            'productId': purchase.productID,
          }
        : {
            'platform': 'ios',
            'signedTransaction':
                purchase.verificationData.serverVerificationData,
          };
    final path = restored ? '/purchases/restore' : '/purchases/validate';
    try {
      final response = await _post(path, body);
      _log.i('$path OK: ${response['data']}');
      if (purchase.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchase);
        _log.i('completePurchase de ${purchase.purchaseID}');
      }
      final expiredMessage = restored ? _expiredMessage(response['data']) : null;
      if (expiredMessage != null) {
        _log.i('restaurar: a assinatura da loja já venceu');
        lastMessage.value = expiredMessage;
        flow.value = PurchaseFlowState.error;
        return;
      }
      lastMessage.value = null;
      flow.value = PurchaseFlowState.success;
    } on AppError catch (e) {
      // 403 é resposta definitiva (a compra é de outro uid, que segue com ela no
      // backend): reentregar não muda nada, então finaliza. Nos outros erros não
      // finaliza: a loja reentrega e tentamos de novo na próxima abertura.
      final notThisAccount = e.code == '403';
      if (notThisAccount && purchase.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchase);
        _log.w('$path recusou (403): ${e.message}. '
            'Compra ${purchase.purchaseID} é de outra conta; finalizada na loja');
      } else {
        _log.e('$path falhou (${e.code}): ${e.message}. '
            'Compra ${purchase.purchaseID} fica sem finalizar para a loja reentregar');
      }
      if (!requested) return;
      lastMessage.value = notThisAccount
          ? e.message
          : 'Recebemos sua compra, mas não conseguimos confirmar agora. Ela será liberada automaticamente.';
      flow.value = PurchaseFlowState.error;
    }
  }

  // Restaurar uma assinatura vencida responde 200 com status "expired" (ou "revoked"): não é sucesso.
  String? _expiredMessage(dynamic data) {
    if (data is! Map) {
      return 'Não encontramos uma assinatura ativa nesta conta da loja.';
    }
    final until = DateTime.tryParse('${data['accessUntil']}')?.toLocal();
    final active = const ['active', 'grace'].contains(data['status']) &&
        until != null &&
        until.isAfter(DateTime.now());
    if (active) return null;
    final ended = until == null ? '' : ' em ${formatDate3(until)}';
    return 'Sua assinatura terminou$ended. Assine de novo para liberar todo o conteúdo.';
  }

  // O app viu o acesso vencer há pouco: pede ao backend para reconsultar a loja.
  Future<void> refresh() async {
    try {
      final response = await _post('/purchases/refresh', const {});
      _log.i('/purchases/refresh: ${response['data']}');
    } on AppError catch (e) {
      _log.w('refresh: ${e.message}');
    }
  }

  void resetFlow() {
    flow.value = PurchaseFlowState.idle;
    lastMessage.value = null;
  }
}
