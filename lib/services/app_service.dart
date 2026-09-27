import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/firestore/app.dart';

// Documento app/infos no Firestore (campos em texto, como se digita no console):
// minVersionName ("1.0.0"), minBuildNumber ("1"), androidStoreUrl, iosStoreUrl.
// A regra do Firestore libera leitura pública de app/{doc}.
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
      minVersionName: map['minVersionName']?.toString(),
      minBuildNumber: map['minBuildNumber']?.toString(),
      androidStoreUrl: map['androidStoreUrl'] as String?,
      iosStoreUrl: map['iosStoreUrl'] as String?,
    );
  }

  @override
  String toString() =>
      'AppInfos(min $minVersionName+$minBuildNumber, android $androidStoreUrl, ios $iosStoreUrl)';
}

class AppService {
  final _log = getLogger('AppService');
  AppInfos? appInfos;

  // Sem rede, sem documento ou além de 4 segundos: segue sem checar versão. A
  // atualização forçada nunca pode travar a abertura de quem está offline.
  Future<void> init() async {
    try {
      appInfos = await getAppInfos().timeout(const Duration(seconds: 4));
      _log.i('app/infos: $appInfos');
    } catch (e) {
      _log.w('app/infos indisponível, segue sem checar versão: $e');
    }
  }
}
