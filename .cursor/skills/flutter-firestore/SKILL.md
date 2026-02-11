---
name: flutter-firestore
description: Implements Firebase Firestore patterns with clean architecture. Use when working with Firestore, database operations, Firebase queries, creating/updating documents, or when the user mentions Firestore, Firebase database, or data persistence.
---

# Firebase Firestore Pattern

## Arquitetura em Camadas

### Fluxo Obrigatório

```
Firestore → Service → ViewModel
```

**NUNCA** acesse Firestore diretamente da ViewModel.

## Organização

Toda lógica Firestore fica em `lib/firestore/`:

```
lib/firestore/user.dart
lib/firestore/chat.dart
lib/firestore/message.dart
```

## Responsabilidades da Camada Firestore

### ✅ Pode

- Acessar coleções e documentos
- Executar get, set, update, snapshots
- Converter `Map<String, dynamic>` em models

### ❌ Não Pode

- Conter regras de negócio
- Acessar BuildContext
- Acessar ValueNotifier ou ViewModels

## Leitura Simples (Padrão)

```dart
Future<UserModel?> getUserById(String userId) async {
  try {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (!doc.exists) return null;

    return UserModel.fromMap(
      doc.data() as Map<String, dynamic>,
      doc.id,
    );
  } catch (error) {
    rethrow;
  }
}
```

## Leitura com Stream (Exceção)

Use apenas quando necessário sincronização em tempo real (ex: usuário logado):

```dart
Future<StreamSubscription> getAndListenUserById({
  required Function(UserModel) onNewSnapshot,
  required String userId,
}) async {
  try {
    final query = FirebaseFirestore.instance
        .collection('users')
        .doc(userId);

    final newSnapshot = await query.get();
    final updatedUser = UserModel.fromMap(
      newSnapshot.data() as Map<String, dynamic>,
      newSnapshot.id,
    );

    await onNewSnapshot(updatedUser);

    return query.snapshots().skip(1).listen((newSnapshot) async {
      final updatedUser = UserModel.fromMap(
        newSnapshot.data() as Map<String, dynamic>,
        newSnapshot.id,
      );
      await onNewSnapshot(updatedUser);
    });
  } catch (error) {
    rethrow;
  }
}
```

## Criação de Documento

```dart
Future<void> createUser({
  required Map<String, dynamic> userMap,
  required String userId,
}) async {
  try {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId);

    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      _log.i('User already exists: $userId');
      return;
    }

    await docRef.set(userMap);
    _log.i('User created with success: $userId, $userMap');
  } catch (error) {
    rethrow;
  }
}
```

## Atualização Parcial

```dart
Future<void> updateUser({
  required Map<String, dynamic> map,
  required String userId,
}) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update(map);
  } catch (error) {
    rethrow;
  }
}
```

## Service Layer

Services orquestram Firestore e protegem ViewModels de mudanças estruturais.

### Exemplo: Usuário Singleton

```dart
ValueNotifier<UserModel?> user = ValueNotifier(null);
StreamSubscription? _userSubscription;

Future<void> setUser(String uid) async {
  try {
    _userSubscription = await firestore.getAndListenUserById(
      onNewSnapshot: (user) {
        this.user.value = user;
      },
      userId: uid,
    );
  } catch (e) {
    rethrow;
  }
}
```

### Exemplo: Atualização via Service

```dart
Future<void> updateUserSex(SexEnum sex) async {
  try {
    await firestore.updateUser(
      map: {
        'sex': sex.name,
      },
      userId: user.value!.id,
    );
  } catch (e) {
    rethrow;
  }
}
```

## Princípios Importantes

- ViewModel **nunca** conhece nomes de campos do Firestore
- Services centralizam decisões de escrita
- Mudanças no banco impactam apenas Services
- Prefira leituras simples sobre streams
