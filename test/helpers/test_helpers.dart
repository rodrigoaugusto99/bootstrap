import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bootstrap/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:bootstrap/services/auth_service.dart';
import 'package:bootstrap/services/app_service.dart';
import 'package:bootstrap/services/api_service.dart';
import 'package:bootstrap/services/google_cloud_logging_service.dart';
import 'package:bootstrap/services/user_service.dart';
import 'package:bootstrap/services/subscription_service.dart';
import 'package:bootstrap/services/notification_service.dart';
import 'package:bootstrap/services/conectivity_service.dart';
import 'package:bootstrap/services/location_service.dart';
import 'package:bootstrap/services/alarm_service.dart';
// @stacked-import

import 'test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<NavigationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<BottomSheetService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DialogService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<AuthService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<AppService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<ApiService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<GoogleCloudLoggingService>(
      onMissingStub: OnMissingStub.returnDefault),
  MockSpec<UserService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<SubscriptionService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<NotificationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<ConectivityService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<LocationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<AlarmService>(onMissingStub: OnMissingStub.returnDefault),
// @stacked-mock-spec
])
void registerServices() {
  getAndRegisterNavigationService();
  getAndRegisterBottomSheetService();
  getAndRegisterDialogService();
  getAndRegisterAuthService();
  getAndRegisterAppService();
  getAndRegisterApiService();
  getAndRegisterGoogleCloudLoggingService();
  getAndRegisterUserService();
  getAndRegisterSubscriptionService();
  getAndRegisterNotificationService();
  getAndRegisterConectivityService();
  getAndRegisterLocationService();
  getAndRegisterAlarmService();
// @stacked-mock-register
}

MockNavigationService getAndRegisterNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MockBottomSheetService getAndRegisterBottomSheetService<T>({
  SheetResponse<T>? showCustomSheetResponse,
}) {
  _removeRegistrationIfExists<BottomSheetService>();
  final service = MockBottomSheetService();

  when(service.showCustomSheet<T, T>(
    enableDrag: anyNamed('enableDrag'),
    enterBottomSheetDuration: anyNamed('enterBottomSheetDuration'),
    exitBottomSheetDuration: anyNamed('exitBottomSheetDuration'),
    ignoreSafeArea: anyNamed('ignoreSafeArea'),
    isScrollControlled: anyNamed('isScrollControlled'),
    barrierDismissible: anyNamed('barrierDismissible'),
    additionalButtonTitle: anyNamed('additionalButtonTitle'),
    variant: anyNamed('variant'),
    title: anyNamed('title'),
    hasImage: anyNamed('hasImage'),
    imageUrl: anyNamed('imageUrl'),
    showIconInMainButton: anyNamed('showIconInMainButton'),
    mainButtonTitle: anyNamed('mainButtonTitle'),
    showIconInSecondaryButton: anyNamed('showIconInSecondaryButton'),
    secondaryButtonTitle: anyNamed('secondaryButtonTitle'),
    showIconInAdditionalButton: anyNamed('showIconInAdditionalButton'),
    takesInput: anyNamed('takesInput'),
    barrierColor: anyNamed('barrierColor'),
    barrierLabel: anyNamed('barrierLabel'),
    customData: anyNamed('customData'),
    data: anyNamed('data'),
    description: anyNamed('description'),
  )).thenAnswer((realInvocation) =>
      Future.value(showCustomSheetResponse ?? SheetResponse<T>()));

  locator.registerSingleton<BottomSheetService>(service);
  return service;
}

MockDialogService getAndRegisterDialogService() {
  _removeRegistrationIfExists<DialogService>();
  final service = MockDialogService();
  locator.registerSingleton<DialogService>(service);
  return service;
}

MockAuthService getAndRegisterAuthService() {
  _removeRegistrationIfExists<AuthService>();
  final service = MockAuthService();
  locator.registerSingleton<AuthService>(service);
  return service;
}

MockAppService getAndRegisterAppService() {
  _removeRegistrationIfExists<AppService>();
  final service = MockAppService();
  locator.registerSingleton<AppService>(service);
  return service;
}

MockApiService getAndRegisterApiService() {
  _removeRegistrationIfExists<ApiService>();
  final service = MockApiService();
  locator.registerSingleton<ApiService>(service);
  return service;
}

MockGoogleCloudLoggingService getAndRegisterGoogleCloudLoggingService() {
  _removeRegistrationIfExists<GoogleCloudLoggingService>();
  final service = MockGoogleCloudLoggingService();
  locator.registerSingleton<GoogleCloudLoggingService>(service);
  return service;
}

MockUserService getAndRegisterUserService() {
  _removeRegistrationIfExists<UserService>();
  final service = MockUserService();
  locator.registerSingleton<UserService>(service);
  return service;
}

MockSubscriptionService getAndRegisterSubscriptionService() {
  _removeRegistrationIfExists<SubscriptionService>();
  final service = MockSubscriptionService();
  locator.registerSingleton<SubscriptionService>(service);
  return service;
}

MockNotificationService getAndRegisterNotificationService() {
  _removeRegistrationIfExists<NotificationService>();
  final service = MockNotificationService();
  locator.registerSingleton<NotificationService>(service);
  return service;
}

MockConectivityService getAndRegisterConectivityService() {
  _removeRegistrationIfExists<ConectivityService>();
  final service = MockConectivityService();
  locator.registerSingleton<ConectivityService>(service);
  return service;
}

MockLocationService getAndRegisterLocationService() {
  _removeRegistrationIfExists<LocationService>();
  final service = MockLocationService();
  locator.registerSingleton<LocationService>(service);
  return service;
}

MockAlarmService getAndRegisterAlarmService() {
  _removeRegistrationIfExists<AlarmService>();
  final service = MockAlarmService();
  locator.registerSingleton<AlarmService>(service);
  return service;
}
// @stacked-mock-create

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
