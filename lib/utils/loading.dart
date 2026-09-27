import 'package:loader_overlay/loader_overlay.dart';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/utils/get_context.dart';

// O loading padrão do app para AÇÕES em que a pessoa espera (salvar, enviar, comprar,
// restaurar, gerar arquivo). Conteúdo da tela carregando usa o esqueleto do design,
// quando houver. A animação fica no LoaderOverlay do main.dart.
// 🔥 OBRIGATÓRIO em todo app: não remover (docs/novo-app, etapa 3).
final _log = getLogger('Loading');

void showLoading(String text) {
  _log.i('showLoading: $text');
  final context = getContext();
  if (context == null || context.loaderOverlay.visible) return;
  context.loaderOverlay.show();
}

void hideLoading(String text) {
  _log.i('hideLoading: $text');
  final context = getContext();
  if (context == null || !context.loaderOverlay.visible) return;
  context.loaderOverlay.hide();
}
