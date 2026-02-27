import 'package:bootstrap/ui/components/app_button.dart';
import 'package:bootstrap/ui/views/try_staggered_animation_two/try_staggered_animation_two_viewmodel.dart';
import 'package:flutter/material.dart';

class GetStartedStepTwo extends StatelessWidget {
  final TryStaggeredAnimationTwoViewModel viewModel;

  const GetStartedStepTwo({super.key, required this.viewModel});

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Center(
        child: Icon(Icons.bolt, color: Colors.white, size: 64),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = viewModel;

    return Stack(
      children: [
        // Content — appears after the logo settles at the top
        Padding(
          padding: const EdgeInsets.only(top: 170, left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeTransition(
                opacity: vm.getStartedTitleFade,
                child: SlideTransition(
                  position: vm.getStartedTitleSlide,
                  child: const Text(
                    'Get started with\nbootstrap',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              FadeTransition(
                opacity: vm.getStartedPhoneFade,
                child: SlideTransition(
                  position: vm.getStartedPhoneSlide,
                  child: SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      text: 'Phone number',
                      onPressed: vm.next,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: vm.getStartedOrFade,
                child: SlideTransition(
                  position: vm.getStartedOrSlide,
                  child: const Center(
                    child: Text(
                      'or',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: vm.getStartedAppleFade,
                child: SlideTransition(
                  position: vm.getStartedAppleSlide,
                  child: SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      text: 'Continue with Apple',
                      onPressed: () {},
                      backgroundColor: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FadeTransition(
                opacity: vm.getStartedGoogleFade,
                child: SlideTransition(
                  position: vm.getStartedGoogleSlide,
                  child: SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      text: 'Continue with Google',
                      onPressed: () {},
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      hasBorder: true,
                      borderColor: Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Logo — starts centered and large, flies to top-center while shrinking
        AnimatedBuilder(
          animation: vm.logoAlignProgress,
          builder: (context, child) {
            return Align(
              alignment: Alignment.lerp(
                Alignment.center,
                const Alignment(0, -0.85),
                vm.logoAlignProgress.value,
              )!,
              child: child,
            );
          },
          child: ScaleTransition(
            scale: vm.logoScale,
            child: FadeTransition(
              opacity: vm.logoFade,
              child: _buildLogo(),
            ),
          ),
        ),
      ],
    );
  }
}
