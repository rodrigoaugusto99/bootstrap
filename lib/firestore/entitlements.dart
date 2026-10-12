import 'package:bootstrap/models/entitlement_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class EntitlementsFirestore {
  final _entitlements = FirebaseFirestore.instance.collection('entitlements');
  final _users = FirebaseFirestore.instance.collection('users');

  Stream<EntitlementModel> watchEntitlement(String uid) {
    try {
      return _entitlements.doc(uid).snapshots().map((doc) {
        final data = doc.data();
        if (data == null) return EntitlementModel.none;
        return EntitlementModel.fromMap(data);
      });
    } catch (error) {
      rethrow;
    }
  }

  // UUID exigido pela Apple na compra: gerado uma vez e guardado em users/{uid}. O backend
  // acha o dono da assinatura por ele. As firestore.rules precisam deixar o próprio usuário
  // gravar este campo.
  Future<String> getOrCreateAppAccountToken(String uid) async {
    try {
      final ref = _users.doc(uid);
      final existing = (await ref.get()).data()?['appAccountToken'] as String?;
      if (existing != null) return existing;
      final token = const Uuid().v4();
      await ref.set({'appAccountToken': token}, SetOptions(merge: true));
      return token;
    } catch (error) {
      rethrow;
    }
  }
}
