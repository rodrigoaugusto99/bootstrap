import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/services/auth_service.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();

  void logout() {
    _authService.signOut();
  }
}
