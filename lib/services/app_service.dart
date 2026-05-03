import 'package:bootstrap/firestore/app.dart';

class AppInfos {
  final String? minVersionName;
  final String? minBuildNumber;
  final String? androidStoreUrl;
  final String? iosStoreUrl;
  AppInfos({
    this.minVersionName,
    this.minBuildNumber,
    this.androidStoreUrl,
    this.iosStoreUrl,
  });
  factory AppInfos.fromMap(Map<String, dynamic> map) {
    return AppInfos(
      minVersionName: map['minVersionName'],
      minBuildNumber: map['minBuildNumber'],
      androidStoreUrl: map['androidStoreUrl'],
      iosStoreUrl: map['iosStoreUrl'],
    );
  }
}

class AppService {
  AppInfos? appInfos;
  Future<void> init() async {
    appInfos = await getAppInfos();
  }
}
