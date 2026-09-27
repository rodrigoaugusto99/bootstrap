import 'package:flutter/widgets.dart';
import 'package:bootstrap/app/app.logger.dart';

// Uma linha por tela aberta e fechada, com os argumentos: com ela dá para refazer o
// caminho que a pessoa percorreu até o problema que relatou.
class RouteLogger extends NavigatorObserver {
  final _log = getLogger('Navegação');

  String _describe(Route<dynamic>? route) {
    if (route == null) return '-';
    final name = route.settings.name ?? route.runtimeType.toString();
    final args = route.settings.arguments;
    return args == null ? name : '$name ($args)';
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _log.i('abriu ${_describe(route)} (vindo de ${_describe(previousRoute)})');

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _log.i('fechou ${_describe(route)} (volta para ${_describe(previousRoute)})');

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      _log.i('trocou ${_describe(oldRoute)} por ${_describe(newRoute)}');

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _log.i('removeu ${_describe(route)}');
}
