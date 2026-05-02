import 'package:daily_words/app/app.logger.dart';

// Com classe:
class LoginViewModel extends BaseViewModel {
  final _log = getLogger('LoginViewModel');

  Future<void> login() async {
    _log.i('login iniciado');
    _log.w('aviso aqui');
    _log.e('erro aqui');
  }
}

// Sem classe (use o nome do arquivo):
final _log = getLogger('startup_viewmodel');
