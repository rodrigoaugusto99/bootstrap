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
