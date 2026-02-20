import 'package:bootstrap/app/app.bottomsheets.dart';
import 'package:bootstrap/app/app.dialogs.dart';
import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/services/auth_service.dart';
import 'package:bootstrap/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _authService = locator<AuthService>();

  void logout() {
    _authService.signOut();
  }
}
