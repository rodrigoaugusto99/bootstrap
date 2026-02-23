import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/app/app.router.dart';
import 'package:bootstrap/services/auth_service.dart';
import 'package:bootstrap/utils/loading.dart';
import 'package:stacked_services/stacked_services.dart';

class RedirectUser {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();

  final _log = getLogger('RedirectUser');

  Future<void> redirectUser() async {
    _navigationService.clearStackAndShow(Routes.tryStaggeredAnimationTwoView);

    return;
    showLoading();
    if (_authService.currUser == null) {
      // bool sawOnboarding = await getBoolSharedPreferences(
      //   SharedPreferencesKeys.sawOnboarding,
      // );
      // if (!sawOnboarding) {
      //   _log.i('redirecting to onboarding view');
      //   _navigationService.replaceWithOnBoardingView();
      //   return;
      // }
      _log.i('redirecting to login view');
      hideLoading();
      _navigationService.replaceWithLoginView();
      return;
    }

    // bool isUserCreated = await _authService.userExists();
    // if (!isUserCreated) {
    //   _log.i('redirecting to register view');
    //   _navigationService.replaceWithRegisterView();
    //   return;
    // }
    _log.i('initializing user logged in');
    await _authService.setupUserLoggedIn();
  }
}
