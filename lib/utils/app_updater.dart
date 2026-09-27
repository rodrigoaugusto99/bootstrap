import 'dart:io' show Platform;

import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/services/app_service.dart';
import 'package:bootstrap/utils/constants.dart';
import 'package:bootstrap/utils/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Atualização forçada: se a versão instalada for menor que a mínima do app/infos, o
// app manda para a loja e não segue. Sem app/infos (offline, documento ausente), segue.
// 🔥 OBRIGATÓRIO em todo app: não remover (ligado no startup_viewmodel).
final _log = getLogger('app_updater.dart');

Future<void> redirectToStore() async {
  final infos = locator<AppService>().appInfos;
  final url = Platform.isIOS
      ? (infos?.iosStoreUrl ?? iosStoreUrl)
      : (infos?.androidStoreUrl ?? androidStoreUrl);
  _log.w('Mandando para a loja: $url');
  openUrl(url);
}

Future<bool> userCanContinueUsingApp() async {
  final infos = locator<AppService>().appInfos;
  final minVersion = infos?.minVersionName;
  final minBuildNumber = infos?.minBuildNumber;
  if (minVersion == null || minBuildNumber == null) {
    _log.w('AppInfos não disponíveis, pulando verificação de atualização');
    return true;
  }
  final userNeedsUpdate = await needToUpdate(minVersion, minBuildNumber);
  if (userNeedsUpdate) {
    await redirectToStore();
    return false;
  }
  return true;
}

Future<void> printCurrentVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();
  _log.i('Versão do usuário: ${packageInfo.version}+${packageInfo.buildNumber}');
}

Future<bool> needToUpdate(String minVersion, String minBuildNumber) async {
  final byBuild = await needsUpdateByBuildNumber(minBuildNumber);
  final byVersion = await needsUpdateByVersion(minVersion);
  _log.i('Versão mínima $minVersion+$minBuildNumber: '
      'atualizar por build=$byBuild, por versão=$byVersion');
  return byBuild || byVersion;
}

Future<bool> needsUpdateByVersion(String minVersion) async {
  final packageInfo = await PackageInfo.fromPlatform();
  return _compareVersions(packageInfo.version, minVersion) < 0;
}

Future<bool> needsUpdateByBuildNumber(String minBuildNumber) async {
  final packageInfo = await PackageInfo.fromPlatform();
  final current = int.tryParse(packageInfo.buildNumber) ?? 0;
  final minimum = int.tryParse(minBuildNumber) ?? 0;
  return current < minimum;
}

int _compareVersions(String v1, String v2) {
  final a = v1.split('.').map((p) => int.tryParse(p) ?? 0).toList();
  final b = v2.split('.').map((p) => int.tryParse(p) ?? 0).toList();
  for (var i = 0; i < a.length || i < b.length; i++) {
    final x = i < a.length ? a[i] : 0;
    final y = i < b.length ? b[i] : 0;
    if (x != y) return x > y ? 1 : -1;
  }
  return 0;
}
