class LoginSchema {
  final String cpf;
  final String password;
  LoginSchema({
    required this.cpf,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cpf': cpf,
      'password': password,
    };
  }

  factory LoginSchema.fromMap(Map<String, dynamic> map) {
    return LoginSchema(
      cpf: map['cpf'] as String,
      password: map['password'] as String,
    );
  }

}
