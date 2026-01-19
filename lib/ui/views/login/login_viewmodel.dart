import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/exceptions/app_error.dart';
import 'package:bootstrap/services/auth_service.dart';
import 'package:bootstrap/utils/constants.dart';
import 'package:bootstrap/utils/toast.dart';
import 'package:bootstrap/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LoginViewModel extends BaseViewModel {
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

  Future<void> handleLogin({
    bool isGoogle = false,
    bool isApple = false,
    bool isEmailAndPassword = false,
  }) async {
    _log.i('handleLogin');
    if (isEmailAndPassword && !formKey.currentState!.validate()) {
      return;
    }
    unfocus();
    try {
      // if (wasAnonymous) {
      //   _log.i('authenticateAnonymousUser');
      //   await authenticateAnonymousUser(
      //     isApple: isApple,
      //     isGoogle: isGoogle,
      //   );
      //   return;
      // }
      if (isEmailAndPassword) {
        if (isRegister) {
          _log.i('registerWithEmailAndPassword');
          registerWithEmailAndPassword();
          //  await atualizarDadosUsuarioNoFirestore();
        } else {
          //_log.w('nao espero entrar aqui nunca');
          // if (wasAnonymous && _authService.currUser != null) {
          //   //todo: fazer logout da conta anonima
          //   await _authService.signOut();
          //   RedirectUser().listenerToRedirectToHome();
          // }
          _log.i('loginWithEmailAndPassword');
          await loginWithEmailAndPassword();
          // await atualizarDadosUsuarioNoFirestore();
        }
      }
      // else if (isGoogle) {
      //   _log.i('signInWithGoogle');
      //   await login(() =>
      //       _authService.signInWithGoogle(accountOwnerId: accountOwnerId));
      //   //await atualizarDadosUsuarioNoFirestore();
      // } else if (isApple) {
      //   _log.i('signInWithApple');
      //   await login(
      //       () => _authService.signInWithApple(accountOwnerId: accountOwnerId));
      //   //await atualizarDadosUsuarioNoFirestore();
      // }
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
}
