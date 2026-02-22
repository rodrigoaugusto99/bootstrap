import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/exceptions/app_error.dart';
import 'package:bootstrap/schemas/authenticate_anonymous_schema.dart';
import 'package:bootstrap/schemas/login_view_schema.dart';
import 'package:bootstrap/services/auth_service.dart';
import 'package:bootstrap/utils/constants.dart';
import 'package:bootstrap/utils/enums.dart';
import 'package:bootstrap/utils/loading.dart';
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
  TextEditingController confirmPasswordController = TextEditingController();

  String? passwordErrorMessage;
  String? confirmPasswordErrorMessage;
  String? emailErrorMessage;

  final formKey = GlobalKey<FormState>();

  final _log = getLogger('LoginViewModel');
  final _authService = locator<AuthService>();

  String get title => isRegister ? 'Cadastrar' : 'Entrar';

  String get buttonLabel => isRegister ? 'Cadastrar' : 'Entrar';

  String get textToggleLogin =>
      isRegister ? 'Já tem conta? Fazer login' : 'Não tem conta? Cadastrar';

  void handleToggleLogin() {
    isRegister ? wantToLogin() : wantToRegister();
  }

  Future<void> handleLogin(LoginProviderEnum provider) async {
    _log.i('handleLogin: ${provider.name}');

    if (provider == LoginProviderEnum.emailAndPassword &&
        !formKey.currentState!.validate()) {
      return;
    }

    unfocus();
    showLoading();

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
        //todo: continuar o após autenticado com sucesso
        hideLoading();
        return;
      }

      switch (provider) {
        case LoginProviderEnum.emailAndPassword:
          if (isRegister) {
            _log.i('registerWithEmailAndPassword');
            await registerWithEmailAndPassword();
            return;
          }

          _log.i('loginWithEmailAndPassword');
          await loginWithEmailAndPassword();

          break;

        case LoginProviderEnum.google:
          _log.i('signInWithGoogle');

          await _authService.signInWithGoogle();
          break;

        case LoginProviderEnum.apple:
          _log.i('signInWithApple');
          _authService.signInWithApple();
          break;

        case LoginProviderEnum.anonymous:
          _log.i('signInAnonymously');
          break;
      }
    } on AppError catch (e) {
      hideLoading();
      AppToast.showToast(text: e.message);
    } on Exception catch (e) {
      hideLoading();
      _log.e(e);
      AppToast.showToast(text: 'Erro ao fazer login');
    }
  }

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
    formKey.currentState?.reset();
    notifyListeners();
  }

  Future<void> loginWithEmailAndPassword() async {
    try {
      //_log.i('loginWithEmailAndPassword');
      showLoading();
      await _authService.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on AppError catch (e) {
      _log.e(e);
      hideLoading();
      passwordErrorMessage = e.message;
      notifyListeners();
    } on Exception catch (e) {
      hideLoading();
      _log.e(e);
      AppToast.showToast(text: 'Credenciais inválidas');
    }
  }

  Future<void> registerWithEmailAndPassword() async {
    try {
      showLoading();
      await _authService.registerEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // hideLoading();
    } on AppError catch (e) {
      hideLoading();
      switch (e.message) {
        case EMAIL_ALREADY_IN_USE:
          emailErrorMessage = EMAIL_ALREADY_IN_USE;
        case WEAK_PASSWORD:
          passwordErrorMessage = WEAK_PASSWORD;
      }
    } on Exception catch (e) {
      hideLoading();
      _log.e(e);
      AppToast.showToast(text: 'Erro ao realizar cadastro');
    } finally {
      notifyListeners();
    }
  }
}
