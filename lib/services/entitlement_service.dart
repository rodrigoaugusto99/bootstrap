import 'dart:async';

import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/firestore/entitlements.dart';
import 'package:bootstrap/models/entitlement_model.dart';
import 'package:bootstrap/services/purchase_service.dart';
import 'package:bootstrap/utils/purchase_enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

// Quem decide se a pessoa é assinante é o backend; o app só lê entitlements/{uid}.
class EntitlementService with WidgetsBindingObserver {
  final _log = getLogger('EntitlementService');
  final _firestore = EntitlementsFirestore();

  final ValueNotifier<EntitlementModel> entitlement =
      ValueNotifier(EntitlementModel.none);
  final ValueNotifier<bool> premium = ValueNotifier(false);

  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<EntitlementModel>? _subscription;
  Timer? _expiryTimer;
  String? _listeningUid;
  DateTime? _refreshAskedAt;

  void init() {
    if (_authSubscription != null) return;
    WidgetsBinding.instance.addObserver(this);
    _authSubscription = FirebaseAuth.instance
        .authStateChanges()
        .listen((user) => _onUidChanged(user?.uid));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) recheck();
  }

  bool get isPremium => entitlement.value.isPremiumAt(DateTime.now());

  void _onUidChanged(String? uid) {
    if (uid == _listeningUid) return;
    _listeningUid = uid;
    _subscription?.cancel();
    _log.i('ouvindo entitlements/$uid');
    if (uid == null) {
      _apply(EntitlementModel.none);
      return;
    }
    _subscription = _firestore.watchEntitlement(uid).listen(
          _apply,
          onError: (Object e) => _log.w('Listener de entitlements: $e'),
        );
  }

  void _apply(EntitlementModel value) {
    _log.i('entitlement recebido: $value');
    entitlement.value = value;
    _recompute();
  }

  // O documento não muda quando o prazo passa: agenda a reavaliação para o
  // instante do vencimento, para a tela trocar sem esperar o próximo evento.
  void _recompute() {
    final now = isPremium;
    if (now != premium.value) {
      _log.i('premium: ${premium.value} → $now '
          '(status ${entitlement.value.status}, até ${entitlement.value.accessUntil})');
    }
    premium.value = now;
    _maybeRefreshSubscription();
    _expiryTimer?.cancel();
    final until = entitlement.value.accessUntil;
    if (premium.value && until != null) {
      final wait =
          until.add(EntitlementModel.renewalSlack).difference(DateTime.now());
      if (wait < const Duration(days: 30)) {
        _expiryTimer = Timer(wait + const Duration(seconds: 1), _recompute);
      }
    }
  }

  // O acesso venceu há pouco (renovação que o webhook ainda não trouxe): pede ao
  // backend para reconsultar a loja, uma vez por sessão.
  void _maybeRefreshSubscription() {
    final current = entitlement.value;
    final until = current.accessUntil;
    if (premium.value || until == null || _refreshAskedAt != null) return;
    final lapsedRecently =
        DateTime.now().difference(until) < const Duration(days: 3);
    final wasActive = current.entitlementStatus == EntitlementStatus.active ||
        current.entitlementStatus == EntitlementStatus.grace;
    if (!lapsedRecently || !wasActive) return;
    _refreshAskedAt = DateTime.now();
    _log.i('acesso venceu em $until; pedindo /refresh ao backend');
    locator<PurchaseService>().refresh();
  }

  void recheck() => _recompute();
}
