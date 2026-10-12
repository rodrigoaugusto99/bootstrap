import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/utils/app_updater.dart';
import 'package:stacked/stacked.dart';

class ForceUpdateDialogModel extends BaseViewModel {
  final _log = getLogger('ForceUpdateDialogModel');

  // O dialog não fecha aqui: ele só some quando a versão instalada passa a valer
  // (a StartupViewModel reavalia ao voltar da loja).
  Future<void> handleUpdate() async {
    _log.i('atualização obrigatória: abrindo a loja');
    await redirectToStore();
  }
}
