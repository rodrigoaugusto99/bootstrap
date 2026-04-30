import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/exceptions/app_error.dart';
import 'package:bootstrap/services/auth_service.dart';
import 'package:bootstrap/utils/loading.dart';
import 'package:bootstrap/utils/redirect_user.dart';
import 'package:bootstrap/utils/toast.dart';
import 'package:stacked/stacked.dart';

class LoginWithGoogleOrAppleViewModel extends BaseViewModel {
  final _log = getLogger('LoginWithGoogleOrAppleViewModel');
  final _authService = locator<AuthService>();

  Future<void> handleLoginWithGoogle() async {
    _log.i('handleLoginWithGoogle');
    showLoading('handleLoginWithGoogle');
    try {
      await _authService.signInWithGoogle();
      RedirectUser();
    } on AppError catch (e) {
      hideLoading('handleLoginWithGoogle');
      AppToast.showToast(text: e.message);
    } on Exception catch (e) {
      hideLoading('handleLoginWithGoogle');
      _log.e(e);
      AppToast.showToast(text: 'Erro ao entrar com Google');
    }
  }

  Future<void> handleLoginWithApple() async {
    _log.i('handleLoginWithApple');
    showLoading('handleLoginWithApple');
    try {
      await _authService.signInWithApple();
      RedirectUser();
    } on AppError catch (e) {
      hideLoading('handleLoginWithApple');
      AppToast.showToast(text: e.message);
    } on Exception catch (e) {
      hideLoading('handleLoginWithApple');
      _log.e(e);
      AppToast.showToast(text: 'Erro ao entrar com Apple');
    }
  }
}
