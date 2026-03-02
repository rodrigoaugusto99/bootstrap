import 'package:flutter/material.dart';

class GetStartedStepTwoAnimations {
  late AnimationController controller;

  late Animation<double> logoFade;
  late Animation<double> logoScale;
  late Animation<double> logoAlignProgress;

  late Animation<double> titleFade;
  late Animation<Offset> titleSlide;
  late Animation<double> phoneFade;
  late Animation<Offset> phoneSlide;
  late Animation<double> orFade;
  late Animation<Offset> orSlide;
  late Animation<double> appleFade;
  late Animation<Offset> appleSlide;
  late Animation<double> googleFade;
  late Animation<Offset> googleSlide;
  late Animation<double> termsFade;
  late Animation<Offset> termsSlide;

  // GetStarted animation timing (duration 2000ms):
  // logo fade in   : 0ms–140ms   → interval(0.00, 0.07)
  // logo stays big : 140ms–500ms (no animation, just visible)
  // logo fly+shrink: 500ms–1000ms → interval(0.25, 0.50)
  // title          : 1040ms–1280ms → interval(0.52, 0.64)
  // phone btn      : 1140ms–1380ms → interval(0.57, 0.69)
  // "or"           : 1240ms–1480ms → interval(0.62, 0.74)
  // apple btn      : 1340ms–1580ms → interval(0.67, 0.79)
  // google btn     : 1440ms–1680ms → interval(0.72, 0.84)
  // terms          : 1540ms–1780ms → interval(0.77, 0.89)
  void setup(TickerProvider vsync, Curve curve) {
    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2000),
    );

    logoFade = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.00, 0.07, curve: Curves.easeOut),
    );

    final logoMoveCurve = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.25, 0.50, curve: Curves.easeInOutCubic),
    );
    logoScale = Tween<double>(begin: 1.0, end: 0.4).animate(logoMoveCurve);
    logoAlignProgress = logoMoveCurve;

    titleFade = CurvedAnimation(
      parent: controller,
      curve: Interval(0.52, 0.64, curve: curve),
    );
    titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.52, 0.64, curve: curve),
    ));

    phoneFade = CurvedAnimation(
      parent: controller,
      curve: Interval(0.57, 0.69, curve: curve),
    );
    phoneSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.57, 0.69, curve: curve),
    ));

    orFade = CurvedAnimation(
      parent: controller,
      curve: Interval(0.62, 0.74, curve: curve),
    );
    orSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.62, 0.74, curve: curve),
    ));

    appleFade = CurvedAnimation(
      parent: controller,
      curve: Interval(0.67, 0.79, curve: curve),
    );
    appleSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.67, 0.79, curve: curve),
    ));

    googleFade = CurvedAnimation(
      parent: controller,
      curve: Interval(0.72, 0.84, curve: curve),
    );
    googleSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.72, 0.84, curve: curve),
    ));

    termsFade = CurvedAnimation(
      parent: controller,
      curve: Interval(0.77, 0.89, curve: curve),
    );
    termsSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.77, 0.89, curve: curve),
    ));
  }

  void run() => controller.forward(from: 0);

  void stop() => controller.stop();

  void dispose() => controller.dispose();
}
