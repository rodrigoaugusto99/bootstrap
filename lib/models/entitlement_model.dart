import 'package:bootstrap/utils/purchase_constants.dart';
import 'package:bootstrap/utils/purchase_enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EntitlementModel {
  const EntitlementModel({
    required this.status,
    required this.accessUntil,
    required this.productId,
    required this.platform,
    required this.autoRenew,
    required this.isTrial,
    this.trialEndsAt,
  });

  final String status;
  final DateTime? accessUntil;
  final String productId;
  final String platform;
  final bool autoRenew;
  final bool isTrial;
  final DateTime? trialEndsAt;

  static const none = EntitlementModel(
    status: 'none',
    accessUntil: null,
    productId: '',
    platform: '',
    autoRenew: false,
    isTrial: false,
  );

  EntitlementStatus get entitlementStatus => switch (status) {
        'active' => EntitlementStatus.active,
        'grace' => EntitlementStatus.grace,
        'expired' => EntitlementStatus.expired,
        'revoked' => EntitlementStatus.revoked,
        _ => EntitlementStatus.none,
      };

  bool get isAnnual => productId == productAnnual;

  @override
  String toString() => 'Entitlement($status até $accessUntil, $productId, '
      '$platform, renova=$autoRenew, teste=$isTrial até $trialEndsAt)';

  // A renovação costuma chegar do backend alguns segundos depois do vencimento. Enquanto
  // o status ainda é "ativo", o acesso não cai nesse intervalo. Expirada e revogada não
  // têm folga: o webhook troca o status na hora.
  static const renewalSlack = Duration(minutes: 10);

  // O documento não muda sozinho quando o prazo passa: quem decide é o relógio.
  bool isPremiumAt(DateTime now) {
    final until = accessUntil;
    return (entitlementStatus == EntitlementStatus.active ||
            entitlementStatus == EntitlementStatus.grace) &&
        until != null &&
        until.add(renewalSlack).isAfter(now);
  }

  factory EntitlementModel.fromMap(Map<String, dynamic> map) =>
      EntitlementModel(
        status: map['status'] as String? ?? 'none',
        accessUntil: (map['accessUntil'] as Timestamp?)?.toDate(),
        productId: map['productId'] as String? ?? '',
        platform: map['platform'] as String? ?? '',
        autoRenew: map['autoRenew'] as bool? ?? false,
        isTrial: map['isTrial'] as bool? ?? false,
        trialEndsAt: (map['trialEndsAt'] as Timestamp?)?.toDate(),
      );
}
