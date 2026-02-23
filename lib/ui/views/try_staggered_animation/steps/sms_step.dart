import 'dart:async';

import 'package:bootstrap/ui/components/pin_code_field.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SmsStep extends StatefulWidget {
  const SmsStep({
    super.key,
  });

  @override
  State<SmsStep> createState() => _SmsStepState();
}

class _SmsStepState extends State<SmsStep> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late StreamController<ErrorAnimationType> _errorAnimationController;

  late Animation<double> firstColumnFade;
  late Animation<Offset> firstColumnSlide;

  late Animation<double> phoneFieldFade;
  late Animation<Offset> phoneFieldSlide;

  late Animation<double> resendFade;
  late Animation<Offset> resendSlide;

  Curve curve = Curves.easeOutCirc;

  @override
  void initState() {
    super.initState();

    _errorAnimationController = StreamController<ErrorAnimationType>();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    //SLIDE 0 - 0.7
    firstColumnFade = CurvedAnimation(
      parent: _controller,
      curve: Interval(0, 0.5, curve: curve),
    );
    firstColumnSlide = Tween(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.5, curve: curve),
    ));

    //SLIDE 0.08 - 0.7
    phoneFieldFade = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.1, 0.7, curve: curve),
    );
    phoneFieldSlide = Tween(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.1, 0.7, curve: curve),
    ));

    //SLIDE 0.08 - 0.7
    resendFade = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.08, 0.7, curve: curve),
    );
    resendSlide = Tween(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.08, 0.7, curve: curve),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _errorAnimationController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          FadeTransition(
            opacity: firstColumnFade,
            child: SlideTransition(
              position: firstColumnSlide,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verificação',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Digite o código enviado por SMS para o seu telefone',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),
          FadeTransition(
            opacity: phoneFieldFade,
            child: SlideTransition(
              position: phoneFieldSlide,
              child: PinCodeField(
                onCompleted: (_) {}, //(_) => widget.onNext(),
                errorAnimationController: _errorAnimationController,
              ),
            ),
          ),
          const SizedBox(height: 40),
          FadeTransition(
            opacity: resendFade,
            child: SlideTransition(
              position: resendSlide,
              child: const Text(
                'Resend code in',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),

          // const SizedBox(height: 32),
          // FadeTransition(
          //   opacity: buttonFade,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.stretch,
          //     children: [
          //       ElevatedButton(
          //         onPressed: widget.onNext,
          //         child: const Padding(
          //           padding: EdgeInsets.symmetric(vertical: 16),
          //           child: Text('Verificar'),
          //         ),
          //       ),
          //       const SizedBox(height: 12),
          //       TextButton(
          //         onPressed: widget.onBack,
          //         child: const Text('Voltar'),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
