import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/firestore/app.dart';

class AppInfos {
  final String? minVersionName;
  final String? minBuildNumber;
  AppInfos({
    this.minVersionName,
    this.minBuildNumber,
  });
  factory AppInfos.fromMap(Map<String, dynamic> map) {
    return AppInfos(
      minVersionName: map['minVersionName'],
      minBuildNumber: map['minBuildNumber'],
    );
  }
}

class AppService {
  AppInfos? appInfos;
  final _log = getLogger('AppService');
  Future<void> init() async {
    appInfos = await getAppInfos();
  }
}
