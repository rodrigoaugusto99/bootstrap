import 'package:bootstrap/app/app.dialogs.dart';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/services/app_service.dart';
import 'package:bootstrap/services/auth_service.dart';
import 'package:bootstrap/utils/app_updater.dart';
import 'package:bootstrap/utils/redirect_user.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:bootstrap/app/app.locator.dart';

class StartupViewModel extends BaseViewModel {
  final BuildContext context;
  StartupViewModel({required this.context});

  AppInfos? get appInfos => locator<AppService>().appInfos;
  final _authService = locator<AuthService>();
  final _log = getLogger('StartupViewModel');

  Future runStartupLogic({
    required Future<void> animationCompleted,
  }) async {
    //LogarteService().init(context);
    // Atualização forçada (app/infos). OBRIGATÓRIO: não remover.
    await locator<AppService>().init();
    if (await needsForcedUpdate()) await _waitForRequiredUpdate();
    await _authService.init();
    // Se o app cobra assinatura (rd_docs/assinaturas.md): descomentar.
    // locator<EntitlementService>().init();
    // unawaited(locator<PurchaseService>().init());
    if (_authService.currUser != null) {
      await _authService.setupUserLoggedIn();
    }

    await animationCompleted;
    RedirectUser();
  }

  // Versão abaixo da mínima: dialog sem saída. Ao voltar da loja sem ter atualizado, ele
  // continua ali (a abertura nunca fica parada); se a mínima caiu ou a versão passou a
  // valer, o dialog fecha e a abertura segue de onde parou.
  Future<void> _waitForRequiredUpdate() async {
    final appService = locator<AppService>();
    final dialogService = locator<DialogService>();
    _log.w('versão abaixo da mínima: mostrando o dialog de atualização');
    final observer = _ResumeObserver(() async {
      await appService.init();
      if (await needsForcedUpdate()) {
        _log.w('voltou da loja e a versão ainda é menor que a mínima');
        return;
      }
      _log.i('versão liberada: fechando o dialog de atualização');
      dialogService.completeDialog(DialogResponse(confirmed: true));
    });
    WidgetsBinding.instance.addObserver(observer);
    try {
      await dialogService.showCustomDialog(
        variant: DialogType.forceUpdate,
        barrierDismissible: false,
      );
    } finally {
      WidgetsBinding.instance.removeObserver(observer);
    }
  }
}

class _ResumeObserver extends WidgetsBindingObserver {
  _ResumeObserver(this.onResumed);

  final Future<void> Function() onResumed;
  bool _running = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || _running) return;
    _running = true;
    onResumed().whenComplete(() => _running = false);
  }
}
