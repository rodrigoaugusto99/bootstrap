# Models

Entidades de domínio persistidas (Firestore, API). Ficam em `lib/models/`.

## Regras

- Todo model deve ter `fromMap` e `toMap`.
- O `id` do Firestore é passado separadamente no `fromMap` — nunca está dentro do `map`.
- Campos com valores pré-definidos devem expor um getter de enum — nunca compare strings soltas fora do model.
- Enums ficam em `lib/utils/enums.dart`.

## Padrão

```dart
class UserModel {
  final String id;
  final String name;
  final String status;

  UserModel({required this.id, required this.name, required this.status});

  // Getter de enum — nunca compare 'approved' diretamente fora do model
  UserStatus get userStatus => switch (status) {
    'pending_approval' => UserStatus.pendingApproval,
    'rejected'         => UserStatus.rejected,
    _                  => UserStatus.approved,
  };

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(id: id, name: map['name'] ?? '', status: map['status'] ?? 'approved');
  }

  Map<String, dynamic> toMap() => {'name': name, 'status': status};
}
```

→ [.claude/models/references/ex_model.dart](../../.claude/models/references/ex_model.dart)
