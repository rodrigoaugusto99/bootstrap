import 'package:bootstrap/services/app_service.dart';
import 'package:bootstrap/services/auth_service.dart';
import 'package:bootstrap/utils/app_updater.dart';
import 'package:bootstrap/utils/redirect_user.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:bootstrap/app/app.locator.dart';

class StartupViewModel extends BaseViewModel {
  final BuildContext context;
  StartupViewModel({required this.context});

  AppInfos? get appInfos => locator<AppService>().appInfos;
  final _authService = locator<AuthService>();

  Future runStartupLogic({
    required Future<void> animationCompleted,
  }) async {
    //LogarteService().init(context);
    // Atualização forçada (app/infos). OBRIGATÓRIO: não remover.
    await locator<AppService>().init();
    final canContinue = await userCanContinueUsingApp();
    if (!canContinue) return;
    await _authService.init();
    if (_authService.currUser != null) {
      await _authService.setupUserLoggedIn();
    }

    await animationCompleted;
    RedirectUser();
  }
}
