# Firestore

Camada de acesso ao banco. Cada arquivo agrupa operações de leitura/escrita de uma coleção.

## Regras

- Só faz queries, try/catches e conversão `Map → Model`.
- Sem lógica de negócio, sem `BuildContext`, sem acesso a Services ou ViewModels.
- Sempre use `rethrow` no catch — quem trata o erro é o Service.
- Use stream (`snapshots()`) somente quando sync em tempo real for necessário; prefira leitura simples.
- Na criação de documentos, verifique se já existe antes de fazer `set`.

## Padrão

```dart
// Leitura simples
Future<UserModel?> getUserById(String userId) async {
  try {
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  } catch (error) {
    rethrow;
  }
}

// Criação sem sobrescrever
Future<void> createUser({required Map<String, dynamic> userMap, required String userId}) async {
  try {
    final docRef = FirebaseFirestore.instance.collection('users').doc(userId);
    if ((await docRef.get()).exists) return;
    await docRef.set(userMap);
  } catch (error) {
    rethrow;
  }
}

// Atualização parcial
Future<void> updateUser({required Map<String, dynamic> map, required String userId}) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(userId).update(map);
  } catch (error) {
    rethrow;
  }
}
```

→ [examples/ex_firestore.dart](../../.claude/examples/ex_firestore.dart)
