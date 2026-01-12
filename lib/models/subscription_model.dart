import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionModel {
  final String userId;
  int? expiryTimeMillis;
  String? priceAmountMicros;
  String subscriptionType;

  // apple
  String? transactionId;

  // google
  String? orderId;
  final Timestamp createdAt;

  SubscriptionModel({
    required this.userId,
    required this.createdAt,
    this.subscriptionType = "",
    this.expiryTimeMillis,
    this.priceAmountMicros,
    this.transactionId,
    this.orderId,
  });

  bool get isRealSubscription {
    return transactionId != null || orderId != null;
  }

  factory SubscriptionModel.fromRawJson(String str) =>
      SubscriptionModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionModel(
        // convert to int if string
        expiryTimeMillis: json["expiryTimeMillis"] != null
            ? int.tryParse(json["expiryTimeMillis"].toString())
            : null,
        priceAmountMicros: json["priceAmountMicros"],
        subscriptionType: json["subscriptionType"] ?? "",
        userId: json["userId"],
        transactionId: json["transactionId"],
        orderId: json["orderId"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "expiryTimeMillis": expiryTimeMillis,
        "priceAmountMicros": priceAmountMicros,
        "subscriptionType": subscriptionType,
        "userId": userId,
        "transactionId": transactionId,
        "orderId": orderId,
        "createdAt": createdAt,
      };
}
