import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/exceptions/app_error.dart';
import 'package:bootstrap/schemas/authenticate_anonymous_schema.dart';
import 'package:bootstrap/schemas/login_view_schema.dart';
import 'package:bootstrap/services/auth_service.dart';
import 'package:bootstrap/utils/constants.dart';
import 'package:bootstrap/utils/enums.dart';
import 'package:bootstrap/utils/toast.dart';
import 'package:bootstrap/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LoginViewModel extends BaseViewModel {
  LoginViewModel({
    required this.schema,
  });
  LoginViewSchema? schema;

  bool isRegister = true;
  bool isLogin = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? passwordErrorMessage;
  String? emailErrorMessage;

  final formKey = GlobalKey<FormState>();

  final _log = getLogger('LoginViewModel');
  final _authService = locator<AuthService>();
  void wantToLogin() {
    isRegister = false;
    isLogin = true;
    reset();
    notifyListeners();
  }

  void wantToRegister() {
    isRegister = true;
    isLogin = false;
    reset();
    notifyListeners();
  }

  void reset() {
    emailController.clear();
    passwordController.clear();
    passwordErrorMessage = null;
    emailErrorMessage = null;
    notifyListeners();
  }

  Future<void> handleLogin(LoginProviderEnum provider) async {
    _log.i('handleLogin: ${provider.name}');

    if (provider == LoginProviderEnum.emailAndPassword &&
        !formKey.currentState!.validate()) {
      return;
    }

    unfocus();

    try {
      if (schema != null && schema!.wasAnonymous) {
        _log.i('authenticateAnonymousUser');
        await _authService.authenticateAnonymousUser(
          AuthenticateAnonymousSchema(
            provider: provider,
            name: '',
            email: emailController.text,
            password: passwordController.text,
          ),
        );
        return;
      }

      switch (provider) {
        case LoginProviderEnum.emailAndPassword:
          if (isRegister) {
            _log.i('registerWithEmailAndPassword');
            await registerWithEmailAndPassword();
            return;
          }
          //_log.w('nao espero entrar aqui nunca');
          // if (wasAnonymous && _authService.currUser != null) {
          //   //todo: fazer logout da conta anonima
          //   await _authService.signOut();
          //   RedirectUser().listenerToRedirectToHome();
          // }
          _log.i('loginWithEmailAndPassword');
          await loginWithEmailAndPassword();

          break;

        case LoginProviderEnum.google:
          _log.i('signInWithGoogle');
          // await login(() =>
          //     _authService.signInWithGoogle(accountOwnerId: accountOwnerId));
          break;

        case LoginProviderEnum.apple:
          _log.i('signInWithApple');
          // await login(
          //     () => _authService.signInWithApple(accountOwnerId: accountOwnerId));
          break;

        case LoginProviderEnum.anonymous:
          _log.i('signInAnonymously');
          break;
      }
    } on Exception catch (e) {
      _log.e(e);
    }
    _log.i('setSharedPreferencesOnBoarding');
  }

  Future<void> loginWithEmailAndPassword() async {
    try {
      //_log.i('loginWithEmailAndPassword');
      await _authService.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on AppError catch (e) {
      _log.e(e);
      passwordErrorMessage = e.message;
      notifyListeners();
    } on Exception catch (e) {
      _log.e(e);
      AppToast.showToast(text: 'Credenciais inválidas');
    }
  }

  Future<void> registerWithEmailAndPassword() async {
    try {
      await _authService.registerEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on AppError catch (e) {
      switch (e.message) {
        case EMAIL_ALREADY_IN_USE:
          emailErrorMessage = EMAIL_ALREADY_IN_USE;
        case WEAK_PASSWORD:
          passwordErrorMessage = WEAK_PASSWORD;
      }
    } on Exception catch (e) {
      _log.e(e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> authenticateAnonymousUser({
    required LoginProviderEnum provider,
  }) async {
    try {
      await _authService.authenticateAnonymousUser(
        AuthenticateAnonymousSchema(
          provider: provider,
          name: '',
          email: emailController.text,
          password: passwordController.text,
        ),
      );

      if (schema != null) {
        _log.i('onAuthenticatedCallback');
        schema!.onAuthenticatedCallback();
      }
    } on AppError catch (e) {
      _log.e(e);
      AppToast.showToast(text: e.message);
    } on Exception catch (e) {
      _log.e(e);
      AppToast.showToast(text: 'Credenciais inválidas');
    }
  }
}
