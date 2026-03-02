import 'package:flutter/material.dart';

class ProfileStepTwoAnimations {
  late AnimationController controller;

  late Animation<double> closeFade;
  late Animation<Offset> closeSlide;
  late Animation<double> titleFade;
  late Animation<Offset> titleSlide;
  late Animation<double> nameRowFade;
  late Animation<Offset> nameRowSlide;
  late Animation<double> emailFade;
  late Animation<Offset> emailSlide;
  late Animation<double> buttonInsideFade;
  late Animation<Offset> buttonInsideSlide;
  late Animation<double> richTextFade;
  late Animation<Offset> richTextSlide;

  // Profile step timing (duration 2000ms):
  // close icon : 0ms–200ms    → interval(0.00, 0.10)
  // title      : 100ms–300ms  → interval(0.05, 0.15)
  // [~500ms gap]
  // name row   : 800ms–1000ms → interval(0.40, 0.50)
  // email      : 900ms–1100ms → interval(0.45, 0.55)
  // button     : 1000ms–1200ms → interval(0.50, 0.60)
  // rich text  : 1100ms–1300ms → interval(0.55, 0.65)
  void setup(TickerProvider vsync, Curve curve) {
    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 3000),
    );

    closeFade = CurvedAnimation(
      parent: controller,
      curve: Interval(0.00, 0.60, curve: curve),
    );
    closeSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.00, 0.60, curve: curve),
    ));

    titleFade = CurvedAnimation(
      parent: controller,
      curve: Interval(0.05, 0.65, curve: curve),
    );
    titleSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.05, 0.65, curve: curve),
    ));

    nameRowFade = CurvedAnimation(
      parent: controller,
      curve: Interval(0.09, 0.70, curve: curve),
    );
    nameRowSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.09, 0.70, curve: curve),
    ));

    emailFade = CurvedAnimation(
      parent: controller,
      curve: Interval(0.11, 0.75, curve: curve),
    );
    emailSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.11, 0.75, curve: curve),
    ));

    buttonInsideFade = CurvedAnimation(
      parent: controller,
      curve: Interval(0.13, 0.60, curve: curve),
    );
    buttonInsideSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.13, 0.60, curve: curve),
    ));

    richTextFade = CurvedAnimation(
      parent: controller,
      curve: Interval(0.15, 0.65, curve: curve),
    );
    richTextSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.15, 0.65, curve: curve),
    ));
  }

  void run() => controller.forward(from: 0);

  void stop() => controller.stop();

  void dispose() => controller.dispose();
}
