import 'package:flutter/material.dart';

class NumberStepTwoAnimations {
  late AnimationController controller;

  late Animation<double> titleFade;
  late Animation<Offset> titleSlide;
  late Animation<double> fieldFade;
  late Animation<Offset> fieldSlide;

  void setup(TickerProvider vsync, Curve curve) {
    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1000),
    );

    titleFade = CurvedAnimation(
      parent: controller,
      curve: Interval(0.0, 0.55, curve: curve),
    );
    titleSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.0, 0.55, curve: curve),
    ));

    fieldFade = CurvedAnimation(
      parent: controller,
      curve: Interval(0.1, 0.7, curve: curve),
    );
    fieldSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.1, 0.7, curve: curve),
    ));
  }

  void run() => controller.forward(from: 0);

  void stop() => controller.stop();

  void dispose() => controller.dispose();
}
