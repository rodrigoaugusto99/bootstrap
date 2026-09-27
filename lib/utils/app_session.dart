import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

// Identifica esta abertura do app. O mesmo id vai nos logs do app (Cloud Logging e
// Crashlytics) e no cabeçalho x-session-id de toda chamada ao backend: é o que liga
// o relato de um usuário ao que aconteceu dos dois lados.
class AppSession {
  static final String id = const Uuid().v4();
  static String version = '';
  static String get platform => Platform.isIOS ? 'ios' : 'android';

  static Future<void> init() async {
    try {
      final info = await PackageInfo.fromPlatform();
      version = '${info.version}+${info.buildNumber}';
    } catch (_) {
      version = 'desconhecida';
    }
  }
}
