import 'dart:async';
import 'package:bootstrap/app/app.bottomsheets.custom.dart';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/firebase_options.dart';
import 'package:bootstrap/ui/common/app_colors.dart';
import 'package:bootstrap/ui/common/app_theme.dart';
import 'package:bootstrap/ui/components/loading.dart';
import 'package:bootstrap/utils/logarte.dart';
import 'package:bootstrap/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap/app/app.dialogs.dart';
import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.router.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:logarte/logarte.dart';
import 'package:stacked_services/stacked_services.dart';

/*
     output: MultiOutput([
      if (!kReleaseMode) ConsoleOutput(),
      if (kReleaseMode) GCPLogger(),
       if (DEVELOPMENT) LogarteOutput(),
    ]),
    filter: ProductionFilter(),
 */
@pragma('vm:entry-point')
Future<void> _handleBackgroundNotification(RemoteMessage message) async {}

Future<void> main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    getLogger('main')
        .e('Flutter Error: ${details.exception}\n${details.stack}');
  };
  await runZonedGuarded(() async {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundNotification);
    await setupLocator();
    setupDialogUi();
    setupBottomSheetUiWithCustomAnimations();

    runApp(const MainApp());
  }, (error, stack) {
    getLogger('main').e('Uncaught Error: $error\n$stack');
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        unfocus();
      },
      child: MaterialApp(
        theme: makeAppTheme(),
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.startupView,
        onGenerateRoute: StackedRouter().onGenerateRoute,
        navigatorKey: StackedService.navigatorKey,
        navigatorObservers: [
          LogarteNavigatorObserver(locator<LogarteService>().logarte),
          StackedService.routeObserver,
          // FirebaseAnalyticsObserver(
          //   analytics: FirebaseAnalytics.instance,
          // ),
        ],
        builder: (context, child) => StyledToast(
          child: LoaderOverlay(
            overlayColor: Colors.black.withValues(alpha: 0.3),
            closeOnBackButton: true,
            overlayWidgetBuilder: (_) {
              return const Center(
                child: CircularProgressIndicator(
                  color: kcPrimaryColor,
                ),
              );
            },
            child: child!,
          ),
        ),
      ),
    );
  }
}
