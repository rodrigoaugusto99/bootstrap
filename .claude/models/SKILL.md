---
name: models
description: Use models como entidades de domínio com fromMap/toMap obrigatórios e getters de enum para campos com valores pré-definidos
---


# Models

Models ficam em `lib/models/` e representam entidades de domínio persistidas (Firestore, API, etc).

## fromMap / toMap

Todo model deve ter `fromMap` e `toMap`. O `id` do Firestore é passado separadamente no `fromMap`.

```dart
factory UserModel.fromMap(Map<String, dynamic> map, String id) { ... }
Map<String, dynamic> toMap() { ... }
```

## Getter de enum para campos com valores pré-definidos

Quando um campo pode assumir um conjunto fixo de valores (ex: `status`, `type`, `role`), declare um enum e exponha um getter — nunca compare strings soltas no código.

O enum fica em `lib/utils/enums.dart`. O getter fica dentro do model.

→ [ex_model.dart](references/ex_model.dart)
