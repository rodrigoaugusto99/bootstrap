import 'dart:async';
import 'package:bootstrap/utils/image_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class Splash extends StatefulWidget {
  final Completer animationCompleter;
  const Splash({super.key, required this.animationCompleter});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Listener para saber quando a animação termina
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Completa o Completer quando a animação terminar
        if (!widget.animationCompleter.isCompleted) {
          isLoading = true;
          setState(() {});
          widget.animationCompleter.complete();
        }
      }
    });

    // Iniciar a animação
    initAnimation();
  }

  Future<void> initAnimation() async {
    _controller.forward();
    await Future.delayed(const Duration(milliseconds: 700));
    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ImageUtil(
              ImageEnum.png,
            ),
            const SizedBox(height: 20),
            Opacity(
              opacity: isLoading ? 1.0 : 0.0,
              child: const CircularProgressIndicator(
                strokeCap: StrokeCap.round,
              ),
            )
          ],
        ),
      ),
    );
  }
}
