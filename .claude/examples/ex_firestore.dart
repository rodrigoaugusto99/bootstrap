// ── lib/firestore/user.dart ──────────────────────────────────────────────────

// Leitura simples
Future<UserModel?> getUserById(String userId) async {
  try {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  } catch (error) {
    rethrow;
  }
}

// Leitura com stream (somente quando necessário sync em tempo real)
Future<StreamSubscription> getAndListenUserById({
  required Function(UserModel) onNewSnapshot,
  required String userId,
}) async {
  try {
    final query = FirebaseFirestore.instance.collection('users').doc(userId);
    final snap = await query.get();
    await onNewSnapshot(UserModel.fromMap(snap.data() as Map<String, dynamic>, snap.id));
    return query.snapshots().skip(1).listen((s) async {
      await onNewSnapshot(UserModel.fromMap(s.data() as Map<String, dynamic>, s.id));
    });
  } catch (error) {
    rethrow;
  }
}

// Criação de documento (sem sobrescrever se já existir)
Future<void> createUser({
  required Map<String, dynamic> userMap,
  required String userId,
}) async {
  try {
    final docRef = FirebaseFirestore.instance.collection('users').doc(userId);
    if ((await docRef.get()).exists) return;
    await docRef.set(userMap);
  } catch (error) {
    rethrow;
  }
}

// Atualização parcial
Future<void> updateUser({
  required Map<String, dynamic> map,
  required String userId,
}) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(userId).update(map);
  } catch (error) {
    rethrow;
  }
}
