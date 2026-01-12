import 'dart:async';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/firestore/subscription.dart' as firestore;
import 'package:bootstrap/models/subscription_model.dart';
import 'package:flutter/material.dart';

class SubscriptionService {
  ValueNotifier<bool> isPremium = ValueNotifier(false);
  StreamSubscription? _subSubscription;
  SubscriptionModel? userSubscriptionModel;
  final _log = getLogger('SubscriptionService');
  Future<void> setSubscription(String uid) async {
    try {
      _subSubscription = await firestore.getUserSubscription(
        onNewSnapshot: (subscription) {
          processSubscription(subscription);
        },
        userId: uid,
      );
    } catch (e) {
      _log.e(e);
      isPremium.value = false;
    }
  }

  void processSubscription(SubscriptionModel? subscription) {
    if (subscription != null) {
      isPremium.value = checkUserSubscription(subscription);
      _log.i("User is premium: ${isPremium.value}");
    } else {
      isPremium.value = false;
    }
  }

  bool checkUserSubscription(SubscriptionModel subscription) {
    // final notificationService = locator<NotificationService>();
    if (subscription.expiryTimeMillis! >
        DateTime.now().millisecondsSinceEpoch) {
      userSubscriptionModel = subscription;
      // notificationService.subscribeToTopic("premium");
      // notificationService.unsubscribeFromTopic("free");
      return true;
    }
    // notificationService.unsubscribeFromTopic("premium");
    // notificationService.subscribeToTopic("free");
    return false;
  }
}
