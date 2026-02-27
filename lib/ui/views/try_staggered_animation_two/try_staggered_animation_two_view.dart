import 'package:bootstrap/ui/components/app_button.dart';
import 'package:bootstrap/ui/components/custom_app_bar.dart';
import 'package:bootstrap/ui/components/custom_bottom_navigation_bar.dart';
import 'package:bootstrap/ui/views/try_staggered_animation_two/steps/get_started_step_two.dart';
import 'package:bootstrap/ui/views/try_staggered_animation_two/steps/number_step_two.dart';
import 'package:bootstrap/ui/views/try_staggered_animation_two/steps/profile_step_two.dart';
import 'package:bootstrap/ui/views/try_staggered_animation_two/steps/sms_step_two.dart';
import 'package:bootstrap/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'try_staggered_animation_two_viewmodel.dart';

class TryStaggeredAnimationTwoView
    extends StackedView<TryStaggeredAnimationTwoViewModel> {
  const TryStaggeredAnimationTwoView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    TryStaggeredAnimationTwoViewModel viewModel,
    Widget? child,
  ) {
    return _AnimatedContent(viewModel: viewModel);
  }

  @override
  TryStaggeredAnimationTwoViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      TryStaggeredAnimationTwoViewModel();
}

class _AnimatedContent extends StatefulWidget {
  final TryStaggeredAnimationTwoViewModel viewModel;

  const _AnimatedContent({required this.viewModel});

  @override
  State<_AnimatedContent> createState() => _AnimatedContentState();
}

class _AnimatedContentState extends State<_AnimatedContent>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.viewModel.init(this);
  }

  @override
  void didUpdateWidget(_AnimatedContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel != widget.viewModel) {
      widget.viewModel.init(this);
    }
  }

  Widget _buildStepWidget(SignupStepTwo step) {
    switch (step) {
      case SignupStepTwo.getStarted:
        return GetStartedStepTwo(viewModel: widget.viewModel);
      case SignupStepTwo.number:
        return NumberStepTwo(viewModel: widget.viewModel);
      case SignupStepTwo.sms:
        return SmsStepTwo(viewModel: widget.viewModel);
      case SignupStepTwo.profile:
        return ProfileStepTwo(viewModel: widget.viewModel);
    }
  }

  // During transition: Stack with the exiting step fading out underneath
  // while the entering step animates in on top — overlapping in time.
  Widget _buildContent() {
    final vm = widget.viewModel;

    if (vm.isTransitioning && vm.previousStep != null) {
      return SizedBox.expand(
        child: Stack(
          children: [
            FadeTransition(
              opacity: vm.contentOpacity,
              child: _buildStepWidget(vm.previousStep!),
            ),
            _buildStepWidget(vm.currentStep),
          ],
        ),
      );
    }

    return _buildStepWidget(vm.currentStep);
  }

  Widget? _buildBottomNav(TryStaggeredAnimationTwoViewModel vm) {
    // GetStarted: show animated terms & conditions text
    if (vm.currentStep == SignupStepTwo.getStarted) {
      return FadeTransition(
        opacity: vm.getStartedTermsFade,
        child: SlideTransition(
          position: vm.getStartedTermsSlide,
          child: CustomBottonNavigationBar(
            widget: AppRichText(
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
      );
    }

    // Profile: no bottom nav (step has its own button inside)
    if (vm.currentStep == SignupStepTwo.profile && !vm.isTransitioning) {
      return null;
    }

    // Number / SMS (and profile while still transitioning in): show "Próximo" button
    return FadeTransition(
      opacity: vm.buttonFade,
      child: SlideTransition(
        position: vm.buttonSlide,
        child: CustomBottonNavigationBar(
          widget: AppButton(
            text: 'Próximo',
            onPressed: vm.next,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;

    return WillPopScope(
      onWillPop: () async {
        vm.back();
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'aa',
          widget: GestureDetector(
            onTap: vm.reset,
            child: const Icon(Icons.reset_tv, color: Colors.white),
          ),
        ),
        bottomNavigationBar: _buildBottomNav(vm),
        // SizedBox.expand ensures the getStarted step (and transition Stack)
        // always fills the full body height for the logo animation to work.
        body: SizedBox.expand(child: _buildContent()),
      ),
    );
  }
}
