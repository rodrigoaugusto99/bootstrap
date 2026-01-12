import 'dart:async';
import 'package:bootstrap/app/app.bottomsheets.custom.dart';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/ui/views/components/loading.dart';
import 'package:bootstrap/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap/app/app.dialogs.dart';
import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.router.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:stacked_services/stacked_services.dart';

/*
     output: MultiOutput([
      if (!kReleaseMode) ConsoleOutput(),
      if (kReleaseMode) GCPLogger(),
       if (DEVELOPMENT) LogarteOutput(),
    ]),
    filter: ProductionFilter(),
 */

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
      child: StyledToast(
        child: LoaderOverlay(
          overlayColor: Colors.black.withOpacity(0.3),
          closeOnBackButton: true,
          overlayWidgetBuilder: (_) {
            return const Loading();
          },
          child: MaterialApp(
            initialRoute: Routes.startupView,
            onGenerateRoute: StackedRouter().onGenerateRoute,
            navigatorKey: StackedService.navigatorKey,
            navigatorObservers: [
              StackedService.routeObserver,
            ],
          ),
        ),
      ),
    );
  }
}
