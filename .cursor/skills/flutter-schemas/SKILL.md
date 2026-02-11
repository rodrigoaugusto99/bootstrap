---
name: flutter-schemas
description: Implements data schemas for structured data transfer between layers. Use when creating DTOs, API request/response objects, or when the user mentions schemas, data transfer objects, too many parameters, or structured data contracts.
---

# Flutter Data Schemas Pattern

## Objetivo

Schemas organizam dados quando funções recebem muitos parâmetros ou quando há troca estruturada entre camadas (API, Firestore, etc).

## Localização

Todos os schemas ficam em `lib/schemas/`:

```
lib/schemas/user_registration_schema.dart
lib/schemas/get_coordinates_from_address_response.dart
```

## Quando Criar um Schema

Crie um schema quando:

- Função começa a receber muitos parâmetros
- Parâmetros fazem parte do mesmo contexto
- Há troca de dados com APIs externas
- Necessidade de converter para `Map<String, dynamic>`

## Estrutura Obrigatória

Todo schema deve ter:

1. Construtor explícito
2. Atributos finais
3. Método `toMap`
4. Factory `fromMap`

**Schemas não contêm lógica de negócio**.

## Exemplo: Schema de Registro

```dart
class UserRegistrationSchema {
  UserRegistrationSchema({required this.name});

  final String name;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory UserRegistrationSchema.fromMap(Map<String, dynamic> map) {
    return UserRegistrationSchema(
      name: map['name'],
    );
  }
}
```

## Uso no Fluxo

### Na ViewModel

```dart
final userRegistrationSchema = UserRegistrationSchema(
  name: fullNameController.text,
);

await _userService.updateUserRegistration(userRegistrationSchema);
```

### No Service

```dart
Future<void> updateUserRegistration(
  UserRegistrationSchema userRegistrationSchema,
) async {
  try {
    await firestore.updateUser(
      map: userRegistrationSchema.toMap(),
      userId: user.value!.id,
    );
  } catch (e) {
    rethrow;
  }
}
```

## Schemas em APIs

### Request e Response

Use schemas separados para request e response:

```dart
Future<GetCoordinatesFromAddressResponse> getCoordinatesFromAddress(
  AddressModel address,
) async {
  final response = await _apiService.request(
    method: HttpMethod.POST,
    url: '$apiUrl/user/geocoding',
    body: address.toMap(),
  );

  return GetCoordinatesFromAddressResponse(
    latitude: response['latitude'],
    longitude: response['longitude'],
  );
}
```

### Exemplo de Response Schema

```dart
class GetCoordinatesFromAddressResponse {
  GetCoordinatesFromAddressResponse({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory GetCoordinatesFromAddressResponse.fromMap(
    Map<String, dynamic> map,
  ) {
    return GetCoordinatesFromAddressResponse(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }
}
```

## Diferença: Schema vs Model

### Schemas
- Dados temporários ou contratuais
- Fluxos, requests, responses
- Atualizações parciais

### Models
- Entidades do domínio
- Dados persistidos
- Centrais ao sistema

**Schemas não substituem models de domínio.**

## Princípios Importantes

- Múltiplos parâmetros → crie um schema
- Troca estruturada entre camadas → use schemas
- APIs → defina schemas de request e response
- Sempre inclua `toMap` e `fromMap`
