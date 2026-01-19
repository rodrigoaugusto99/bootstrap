import 'dart:async';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _log = getLogger('UserService');

Future<StreamSubscription> getUserById({
  required Function(UserModel) onNewSnapshot,
  required String userId,
}) async {
  try {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('instructors');

    final query = usersCollection.doc(userId);

    final newSnapshot = await query.get();
    final updatedUser = UserModel.fromMap(
        newSnapshot.data() as Map<String, dynamic>, newSnapshot.id);

    await onNewSnapshot(updatedUser);

    return query.snapshots().skip(1).listen((newSnapshot) async {
      final updatedUser = UserModel.fromMap(
          newSnapshot.data() as Map<String, dynamic>, newSnapshot.id);
      await onNewSnapshot(updatedUser);
    });
  } catch (error) {
    rethrow;
  }
}

Future<void> updateUser({
  required Map<String, dynamic> map,
  required String userId,
}) async {
  try {
    await FirebaseFirestore.instance
        .collection('instructors')
        .doc(userId)
        .update(map);
  } catch (error) {
    rethrow;
  }
}

Future<void> createUser({
  required Map<String, dynamic> userMap,
  required String userId,
}) async {
  try {
    final docRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      _log.i('User already exists: $userId');
      return;
    }
    docRef.set(userMap);
    _log.i('User created with success: $userId, $userMap');
  } catch (error) {
    rethrow;
  }
}
