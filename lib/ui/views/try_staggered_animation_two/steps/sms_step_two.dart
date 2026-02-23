import 'dart:async';

import 'package:bootstrap/ui/components/pin_code_field.dart';
import 'package:bootstrap/ui/views/try_staggered_animation_two/try_staggered_animation_two_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SmsStepTwo extends StatefulWidget {
  final TryStaggeredAnimationTwoViewModel viewModel;

  const SmsStepTwo({super.key, required this.viewModel});

  @override
  State<SmsStepTwo> createState() => _SmsStepTwoState();
}

class _SmsStepTwoState extends State<SmsStepTwo> {
  late StreamController<ErrorAnimationType> _errorAnimationController;

  @override
  void initState() {
    super.initState();
    _errorAnimationController = StreamController<ErrorAnimationType>();
  }

  @override
  void dispose() {
    _errorAnimationController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          FadeTransition(
            opacity: vm.smsTitleFade,
            child: SlideTransition(
              position: vm.smsTitleSlide,
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
            opacity: vm.smsPinFade,
            child: SlideTransition(
              position: vm.smsPinSlide,
              child: PinCodeField(
                onCompleted: (_) {},
                errorAnimationController: _errorAnimationController,
              ),
            ),
          ),
          const SizedBox(height: 40),
          FadeTransition(
            opacity: vm.smsResendFade,
            child: SlideTransition(
              position: vm.smsResendSlide,
              child: const Text(
                'Resend code in',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
