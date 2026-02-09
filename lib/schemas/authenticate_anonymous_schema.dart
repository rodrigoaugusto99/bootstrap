import 'package:bootstrap/utils/enums.dart';

class AuthenticateAnonymousSchema {
  AuthenticateAnonymousSchema({
    required this.provider,
    required this.name,
    required this.email,
    required this.password,
  });

  final LoginProviderEnum provider;
  final String name;
  final String email;
  final String password;
}
