import 'package:bootstrap/ui/components/custom_text_form_field.dart';
import 'package:bootstrap/ui/views/try_staggered_animation_two/try_staggered_animation_two_viewmodel.dart';
import 'package:flutter/material.dart';

class NumberStepTwo extends StatefulWidget {
  final TryStaggeredAnimationTwoViewModel viewModel;

  const NumberStepTwo({super.key, required this.viewModel});

  @override
  State<NumberStepTwo> createState() => _NumberStepTwoState();
}

class _NumberStepTwoState extends State<NumberStepTwo> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final anims = widget.viewModel.numberAnimations;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          FadeTransition(
            opacity: anims.titleFade,
            child: SlideTransition(
              position: anims.titleSlide,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter your number',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'A verification code will be sent via SMS',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          FadeTransition(
            opacity: anims.fieldFade,
            child: SlideTransition(
              position: anims.fieldSlide,
              child: CustomTextFormField(
                controller: _phoneController,
                textInputAction: TextInputAction.next,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
