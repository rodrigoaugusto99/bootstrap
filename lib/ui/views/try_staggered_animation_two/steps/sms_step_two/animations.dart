import 'package:flutter/material.dart';

class SmsStepTwoAnimations {
  late AnimationController controller;

  late Animation<double> titleFade;
  late Animation<Offset> titleSlide;
  late Animation<double> pinFade;
  late Animation<Offset> pinSlide;
  late Animation<double> resendFade;
  late Animation<Offset> resendSlide;

  void setup(TickerProvider vsync, Curve curve) {
    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2000),
    );

    titleFade = CurvedAnimation(
      parent: controller,
      curve: Interval(0.0, 0.5, curve: curve),
    );
    titleSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.0, 0.5, curve: curve),
    ));

    pinFade = CurvedAnimation(
      parent: controller,
      curve: Interval(0.1, 0.7, curve: curve),
    );
    pinSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.1, 0.7, curve: curve),
    ));

    resendFade = CurvedAnimation(
      parent: controller,
      curve: Interval(0.2, 0.75, curve: curve),
    );
    resendSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.2, 0.75, curve: curve),
    ));
  }

  void run() => controller.forward(from: 0);

  void stop() => controller.stop();

  void dispose() => controller.dispose();
}
