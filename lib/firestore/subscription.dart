import 'dart:async';
import 'package:bootstrap/models/subscription_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<StreamSubscription> getUserSubscription({
  required Function(SubscriptionModel?) onNewSnapshot,
  required String userId,
}) async {
  try {
    final subCollectionRef = FirebaseFirestore.instance
        .collection('subscriptions')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(1);

    final querySnapshot = await subCollectionRef.get();
    SubscriptionModel? subscription;
    if (querySnapshot.docs.isNotEmpty) {
      subscription =
          SubscriptionModel.fromJson(querySnapshot.docs.first.data());
    }
    await onNewSnapshot(subscription);

    return subCollectionRef.snapshots().skip(1).listen((snapshot) async {
      SubscriptionModel? subscription;
      if (snapshot.docs.isNotEmpty) {
        subscription = SubscriptionModel.fromJson(snapshot.docs.first.data());
      }
      await onNewSnapshot(subscription);
    });
  } catch (error) {
    rethrow;
  }
}
