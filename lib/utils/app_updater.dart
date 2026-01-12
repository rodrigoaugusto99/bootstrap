import 'package:bootstrap/utils/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io' show Platform;

Future<void> redirectToStore() async {
  String url = '';

  if (Platform.isAndroid) {
    url = '';
  } else if (Platform.isIOS) {
    url = '';
  } else {
    return;
  }
  openUrl(url);
}

void printCurrentVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();
  final version = packageInfo.version;
  final buildNumber = packageInfo.buildNumber;
  print('Versão do usuário: $version+$buildNumber');
}

//final _log = getLogger('app_updater.dart');
Future<bool> needsUpdateByVersion(String minVersion) async {
  final packageInfo = await PackageInfo.fromPlatform();
  final version = packageInfo.version;
  return _compareVersions(version, minVersion) < 0;
}

Future<bool> needsUpdateByBuildNumber(String minBuildNumber) async {
  final packageInfo = await PackageInfo.fromPlatform();
  final buildNumber = packageInfo.buildNumber;
  return int.parse(buildNumber) < int.parse(minBuildNumber);
}

int _compareVersions(String v1, String v2) {
  final v1Parts = v1.split('.').map(int.parse).toList();
  final v2Parts = v2.split('.').map(int.parse).toList();

  for (var i = 0; i < v1Parts.length; i++) {
    if (v1Parts[i] > v2Parts[i]) return 1;
    if (v1Parts[i] < v2Parts[i]) return -1;
  }
  return 0;
}
