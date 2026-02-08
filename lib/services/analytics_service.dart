class AnalyticsService {
  //  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  // UserService get _userService => locator<UserService>();
  // AuthService get _authService => locator<AuthService>();

  // Map<String, Object> _getUserContext() {
  //   final isLoggedIn = _authService.isUserLoggedIn.value;

  //   final user = _userService.user.value;

  //   if (isLoggedIn && user != null) {
  //     return {
  //       'user_id': user.id,
  //       'user_name': user.name,
  //       'user_email': user.whatsapp ?? '',
  //       'is_logged_in': 'true',
  //     };
  //   }

  //   return {'is_logged_in': 'false'};
  // }

  // Map<String, Object> _getCommonParameters({
  //   required String screenName,
  //   Map<String, Object>? additionalParams,
  // }) {
  //   final baseParams = {
  //     'screen_name': screenName,
  //     'timestamp': DateTime.now().millisecondsSinceEpoch,
  //     ..._getUserContext(),
  //   };

  //   if (additionalParams != null) {
  //     baseParams.addAll(additionalParams);
  //   }

  //   return baseParams;
  // }

  // Future<void> logEvent({
  //   required String name,
  //   Map<String, Object>? parameters,
  // }) async {
  //   try {
  //     await _analytics.logEvent(name: name, parameters: parameters);

  //     if (kDebugMode) {
  //       debugPrint('Analytics Event: $name - $parameters');
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       debugPrint('Analytics Event Error: $e');
  //     }
  //   }
  // }

  // Future<void> logScreenView({
  //   required String screenName,
  //   Map<String, Object>? additionalParams,
  // }) async {
  //   try {
  //     await _analytics.logScreenView(screenName: screenName);

  //     final parameters = _getCommonParameters(
  //       screenName: screenName,
  //       additionalParams: additionalParams,
  //     );

  //     await logEvent(name: 'screen_viewed', parameters: parameters);

  //     if (kDebugMode) {
  //       debugPrint('Analytics Screen: $screenName');
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       debugPrint('Analytics Screen Error: $e');
  //     }
  //   }
  // }

  // Future<void> logNavigation({
  //   required String fromScreen,
  //   required String toScreen,
  //   Map<String, Object>? additionalParams,
  // }) async {
  //   final parameters = _getCommonParameters(
  //     screenName: fromScreen,
  //     additionalParams: {
  //       'navigation_to': toScreen,
  //       'navigation_type': 'screen_transition',
  //       ...?additionalParams,
  //     },
  //   );

  //   await logEvent(name: 'navigation', parameters: parameters);
  // }

  // Future<void> logButtonTap({
  //   required String buttonName,
  //   required String screenName,
  //   Map<String, Object>? additionalParams,
  // }) async {
  //   final parameters = _getCommonParameters(
  //     screenName: screenName,
  //     additionalParams: {
  //       'button_name': buttonName,
  //       'action_type': 'button_tap',
  //       ...?additionalParams,
  //     },
  //   );

  //   await logEvent(name: 'button_tapped', parameters: parameters);
  // }

  // Future<void> logError({
  //   required String error,
  //   required String fatal,
  //   required String screenName,
  //   Map<String, Object>? additionalParams,
  // }) async {
  //   final parameters = _getCommonParameters(
  //     screenName: screenName,
  //     additionalParams: {
  //       'error_message': error,
  //       'fatal': fatal,
  //       'error_type': 'app_error',
  //       ...?additionalParams,
  //     },
  //   );

  //   await logEvent(name: 'app_error', parameters: parameters);
  // }

  // Future<void> logLogin({
  //   required String method,
  //   Map<String, Object>? additionalParams,
  // }) async {
  //   final parameters = _getCommonParameters(
  //     screenName: 'login_screen',
  //     additionalParams: {
  //       'login_method': method,
  //       'action_type': 'user_login',
  //       ...?additionalParams,
  //     },
  //   );

  //   try {
  //     await _analytics.logLogin(loginMethod: method);
  //     await logEvent(name: 'login_successful', parameters: parameters);
  //   } catch (e) {
  //     if (kDebugMode) {
  //       debugPrint('Analytics Login Error: $e');
  //     }
  //   }
  // }

  // Future<void> logSignUp({
  //   required String method,
  //   Map<String, Object>? additionalParams,
  // }) async {
  //   final parameters = _getCommonParameters(
  //     screenName: 'register_screen',
  //     additionalParams: {
  //       'sign_up_method': method,
  //       'action_type': 'user_sign_up',
  //       ...?additionalParams,
  //     },
  //   );

  //   try {
  //     await _analytics.logSignUp(signUpMethod: method);
  //     await logEvent(name: 'sign_up_successful', parameters: parameters);
  //   } catch (e) {
  //     if (kDebugMode) {
  //       debugPrint('Analytics Sign Up Error: $e');
  //     }
  //   }
  // }

  // Future<void> logLogout({
  //   required String screenName,
  //   Map<String, Object>? additionalParams,
  // }) async {
  //   final parameters = _getCommonParameters(
  //     screenName: screenName,
  //     additionalParams: {'action_type': 'user_logout', ...?additionalParams},
  //   );

  //   await logEvent(name: 'logout', parameters: parameters);
  // }

  // Future<void> logPurchase({
  //   required String currency,
  //   required double value,
  //   required String screenName,
  //   Map<String, Object>? additionalParams,
  // }) async {
  //   final parameters = _getCommonParameters(
  //     screenName: screenName,
  //     additionalParams: {
  //       'currency': currency,
  //       'value': value,
  //       'action_type': 'purchase',
  //       ...?additionalParams,
  //     },
  //   );

  //   try {
  //     await _analytics.logPurchase(
  //       currency: currency,
  //       value: value,
  //       parameters: parameters,
  //     );
  //   } catch (e) {
  //     if (kDebugMode) {
  //       debugPrint('Analytics Purchase Error: $e');
  //     }
  //   }
  // }
}
