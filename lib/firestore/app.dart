import 'package:bootstrap/services/app_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<AppInfos> getAppInfos() async {
  try {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('app');

    final query = usersCollection.doc('infos');

    final newSnapshot = await query.get();
    final appInfos =
        AppInfos.fromMap(newSnapshot.data() as Map<String, dynamic>);

    return appInfos;
  } catch (error) {
    rethrow;
  }
}
