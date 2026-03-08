// ── lib/schemas/user_registration_schema.dart ─────────────────────────────────
class UserRegistrationSchema {
  UserRegistrationSchema({required this.name, required this.phone});

  final String name;
  final String phone;

  Map<String, dynamic> toMap() => {'name': name, 'phone': phone};

  factory UserRegistrationSchema.fromMap(Map<String, dynamic> map) =>
      UserRegistrationSchema(name: map['name'], phone: map['phone']);
}

// ── Uso na ViewModel ──────────────────────────────────────────────────────────
Future<void> register() async {
  try {
    final schema = UserRegistrationSchema(
      name: nameController.text,
      phone: phoneController.text,
    );
    await _userService.updateUserRegistration(schema);
  } on AppError catch (e) {
    _log.e(e);
  }
}

// ── Uso no Service ─────────────────────────────────────────────────────────────
Future<void> updateUserRegistration(UserRegistrationSchema schema) async {
  try {
    await _firestore.updateUser(
      map: schema.toMap(),
      userId: user.value!.id,
    );
  } catch (e) {
    rethrow;
  }
}


// ── Response de API ───────────────────────────────────────────────────────────
class GetCoordinatesFromAddressResponse {
  GetCoordinatesFromAddressResponse({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  Map<String, dynamic> toMap() => {'latitude': latitude, 'longitude': longitude};

  factory GetCoordinatesFromAddressResponse.fromMap(Map<String, dynamic> map) =>
      GetCoordinatesFromAddressResponse(
        latitude: map['latitude'] as double,
        longitude: map['longitude'] as double,
      );
}
