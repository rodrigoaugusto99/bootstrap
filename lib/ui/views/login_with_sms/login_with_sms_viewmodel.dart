import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/app/app.router.dart';
import 'package:bootstrap/services/auth_service.dart';
import 'package:bootstrap/utils/loading.dart';
import 'package:bootstrap/utils/redirect_user.dart';
import 'package:bootstrap/utils/toast.dart';
import 'package:bootstrap/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginWithSmsViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  //final _analyticsService = locator<AnalyticsService>();
  final phoneController = TextEditingController();
  final _log = getLogger('LoginViewModel');
  final _navigationService = locator<NavigationService>();
  final formKey = GlobalKey<FormState>();
  final String screenName = 'login_screen';
  Future<void> login() async {
    _log.i('login');
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }
      showLoading();
      unfocus();
      await _authService.sendCode(
        phoneNumber: phoneController.text,
        onSent: (params) async {
          // _analyticsService.logSMSCodeSent(
          //   screenName: screenName,
          // );
          hideLoading();
          _navigationService.navigateToEnterCodeView(
            codeSentParams: params,
            phoneNumber: phoneController.text,
            onVerified: () {
              RedirectUser();
            },
          );
        },
        onError: (message) async {
          hideLoading();
          AppToast.showToast(
            text: message,
            type: ToastType.error,
          );
        },
      );
    } catch (e) {
      _log.e(e);
      hideLoading();
      AppToast.showToast(
        text: 'Erro ao enviar código',
      );
    }
  }

  void navigateToTerms() {
    _navigationService.navigateToTermsView();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}
