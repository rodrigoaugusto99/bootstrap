import 'package:bootstrap/services/app_service.dart';
import 'package:bootstrap/services/auth_service.dart';
import 'package:bootstrap/services/google_cloud_logging_service.dart';
import 'package:bootstrap/utils/app_updater.dart';
import 'package:bootstrap/utils/logarte.dart';
import 'package:bootstrap/utils/redirect_user.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:bootstrap/app/app.locator.dart';

class StartupViewModel extends BaseViewModel {
  final BuildContext context;
  StartupViewModel({required this.context});

  AppInfos? get appInfos => locator<AppService>().appInfos;
  Future runStartupLogic({
    required Future<void> animationCompleted,
  }) async {
    locator<LogarteService>().init(context);
    await locator<GoogleCloudLoggingService>().setupLoggingApi();
    await locator<AppService>().init();
    await locator<AuthService>().init();

    bool userNeedsUpdate = await needToUpdate(
      appInfos?.minVersion ?? '',
      appInfos?.minBuildNumber ?? '',
    );
    if (userNeedsUpdate) {
      await redirectToStore();
      return;
    }
    await animationCompleted;
    await RedirectUser().redirectUser();
  }
}
