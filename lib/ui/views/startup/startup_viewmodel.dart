import 'package:bootstrap/services/auth_service.dart';
import 'package:bootstrap/services/google_cloud_logging_service.dart';
import 'package:bootstrap/utils/logarte.dart';
import 'package:bootstrap/utils/redirect_user.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:bootstrap/app/app.locator.dart';

class StartupViewModel extends BaseViewModel {
  final BuildContext context;
  StartupViewModel({required this.context});
  Future runStartupLogic({
    required Future<void> animationCompleted,
  }) async {
    locator<LogarteService>().init(context);
    await locator<GoogleCloudLoggingService>().setupLoggingApi();
    await locator<AuthService>().init();
    await animationCompleted;
    await RedirectUser().redirectUser();
  }
}
