import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateNotification(
  String notificationId,
  Map<String, dynamic> data,
) async {
  try {
    DocumentReference notificationRef = FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationId);

    await notificationRef.update(data);
  } catch (e) {
    rethrow;
  }
}
