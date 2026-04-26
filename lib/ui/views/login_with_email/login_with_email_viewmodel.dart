import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/exceptions/app_error.dart';
import 'package:bootstrap/services/auth_service.dart';
import 'package:bootstrap/utils/constants.dart';
import 'package:bootstrap/utils/loading.dart';
import 'package:bootstrap/utils/redirect_user.dart';
import 'package:bootstrap/utils/toast.dart';
import 'package:bootstrap/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LoginWithEmailViewModel extends BaseViewModel {
  bool isRegister = true;
  bool isLogin = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? emailErrorMessage;
  String? passwordErrorMessage;

  final _log = getLogger('LoginWithEmailViewModel');
  final _authService = locator<AuthService>();

  String get title => isRegister ? 'Cadastrar' : 'Entrar';
  String get buttonLabel => isRegister ? 'Cadastrar' : 'Entrar';
  String get textToggle =>
      isRegister ? 'Já tem conta? Fazer login' : 'Não tem conta? Cadastrar';

  void handleToggle() {
    isRegister ? _wantToLogin() : _wantToRegister();
  }

  void _wantToLogin() {
    isRegister = false;
    isLogin = true;
    _reset();
  }

  void _wantToRegister() {
    isRegister = true;
    isLogin = false;
    _reset();
  }

  void _reset() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    emailErrorMessage = null;
    passwordErrorMessage = null;
    formKey.currentState?.reset();
    notifyListeners();
  }

  Future<void> handleSubmit() async {
    if (!formKey.currentState!.validate()) return;
    unfocus();
    showLoading();

    try {
      if (isRegister) {
        await _registerWithEmailAndPassword();
      } else {
        await _loginWithEmailAndPassword();
      }
    } on AppError catch (e) {
      hideLoading();
      AppToast.showToast(text: e.message);
    } on Exception catch (e) {
      hideLoading();
      _log.e(e);
      AppToast.showToast(text: 'Erro ao autenticar');
    }
  }

  Future<void> _loginWithEmailAndPassword() async {
    try {
      await _authService.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      RedirectUser();
    } on AppError catch (e) {
      hideLoading();
      _log.e(e);
      passwordErrorMessage = e.message;
      notifyListeners();
    } on Exception catch (e) {
      hideLoading();
      _log.e(e);
      AppToast.showToast(text: 'Credenciais inválidas');
    }
  }

  Future<void> _registerWithEmailAndPassword() async {
    try {
      await _authService.registerEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      RedirectUser();
    } on AppError catch (e) {
      hideLoading();
      switch (e.message) {
        case EMAIL_ALREADY_IN_USE:
          emailErrorMessage = EMAIL_ALREADY_IN_USE;
        case WEAK_PASSWORD:
          passwordErrorMessage = WEAK_PASSWORD;
      }
      notifyListeners();
    } on Exception catch (e) {
      hideLoading();
      _log.e(e);
      AppToast.showToast(text: 'Erro ao realizar cadastro');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
