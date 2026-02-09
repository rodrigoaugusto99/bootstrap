import 'dart:ui';

class LoginViewSchema {
  LoginViewSchema({
    required this.wasAnonymous,
    required this.onAuthenticatedCallback,
  });

  final bool wasAnonymous;
  final VoidCallback onAuthenticatedCallback;
}
