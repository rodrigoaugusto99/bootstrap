import 'package:bootstrap/ui/components/app_button.dart';
import 'package:bootstrap/ui/components/custom_text_form_field.dart';
import 'package:bootstrap/ui/views/try_staggered_animation_two/try_staggered_animation_two_viewmodel.dart';
import 'package:bootstrap/utils/helpers.dart';
import 'package:flutter/material.dart';

class ProfileStepTwo extends StatefulWidget {
  final TryStaggeredAnimationTwoViewModel viewModel;

  const ProfileStepTwo({super.key, required this.viewModel});

  @override
  State<ProfileStepTwo> createState() => _ProfileStepTwoState();
}

class _ProfileStepTwoState extends State<ProfileStepTwo> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
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
          const SizedBox(height: 60),
          FadeTransition(
            opacity: vm.profileCloseFade,
            child: SlideTransition(
              position: vm.profileCloseSlide,
              child: GestureDetector(
                onTap: vm.closeProfile,
                child: const Icon(Icons.close, size: 28),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeTransition(
            opacity: vm.profileTitleFade,
            child: SlideTransition(
              position: vm.profileTitleSlide,
              child: const Text(
                'Complete your profile',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 32),
          FadeTransition(
            opacity: vm.profileNameRowFade,
            child: SlideTransition(
              position: vm.profileNameRowSlide,
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      controller: _firstNameController,
                      label: 'First name',
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextFormField(
                      controller: _lastNameController,
                      label: 'Last name',
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeTransition(
            opacity: vm.profileEmailFade,
            child: SlideTransition(
              position: vm.profileEmailSlide,
              child: CustomTextFormField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeTransition(
            opacity: vm.profileButtonInsideFade,
            child: SlideTransition(
              position: vm.profileButtonInsideSlide,
              child: SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Continue',
                  onPressed: vm.finishProfile,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeTransition(
            opacity: vm.profileRichTextFade,
            child: SlideTransition(
              position: vm.profileRichTextSlide,
              child: AppRichText(
                textAlign: TextAlign.center,
                children: const [
                  TextSpan(text: 'By signing up, you are agreeing to our '),
                  TextSpan(
                    text: 'Terms and Conditions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
