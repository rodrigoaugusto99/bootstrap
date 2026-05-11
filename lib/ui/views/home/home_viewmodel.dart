import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/services/auth_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();

  String version = '';

  Future<void> getVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    final buildNumber = packageInfo.buildNumber;
    //_log.i('versão: $currentVersion+$buildNumber');
    version = 'Versão: $currentVersion+$buildNumber';
    notifyListeners();
  }

  void logout() {
    _authService.signOut();
  }
}
