import 'package:bootstrap/services/conectivity_service.dart';
import 'package:bootstrap/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:bootstrap/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:bootstrap/ui/views/home/home_view.dart';
import 'package:bootstrap/ui/views/startup/startup_view.dart';
import 'package:bootstrap/utils/GCPLogger.dart';
import 'package:bootstrap/utils/logarte.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:bootstrap/services/auth_service.dart';
import 'package:bootstrap/services/app_service.dart';
import 'package:bootstrap/services/api_service.dart';
import 'package:bootstrap/services/google_cloud_logging_service.dart';
import 'package:bootstrap/ui/views/login/login_view.dart';
import 'package:bootstrap/ui/views/register/register_view.dart';
import 'package:bootstrap/ui/views/on_boarding/on_boarding_view.dart';
import 'package:bootstrap/services/user_service.dart';
import 'package:bootstrap/services/subscription_service.dart';
import 'package:bootstrap/services/notification_service.dart';
import 'package:bootstrap/services/location_service.dart';
import 'package:bootstrap/services/alarm_service.dart';
import 'package:bootstrap/ui/views/complex_register/complex_register_view.dart';
import 'package:bootstrap/services/analytics_service.dart';
import 'package:bootstrap/ui/views/try_staggered_animation/try_staggered_animation_view.dart';
import 'package:bootstrap/ui/views/try_staggered_animation_two/try_staggered_animation_two_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: RegisterView),
    MaterialRoute(page: OnBoardingView),
    MaterialRoute(page: ComplexRegisterView),
    MaterialRoute(page: TryStaggeredAnimationView),
    MaterialRoute(page: TryStaggeredAnimationTwoView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: AuthService),
    LazySingleton(classType: AppService),
    LazySingleton(classType: ApiService),
    LazySingleton(classType: GoogleCloudLoggingService),
    LazySingleton(classType: UserService),
    LazySingleton(classType: SubscriptionService),
    LazySingleton(classType: NotificationService),
    LazySingleton(classType: ConnectivityService),
    LazySingleton(classType: LocationService),
    LazySingleton(classType: AlarmService),
    LazySingleton(classType: AnalyticsService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
  logger: StackedLogger(
    loggerOutputs: [
      GCPLogger,
      LogarteOutput,
    ],
  ),
)
class App {}
