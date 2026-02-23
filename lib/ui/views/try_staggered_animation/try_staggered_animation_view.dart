import 'package:bootstrap/ui/components/app_button.dart';
import 'package:bootstrap/ui/components/custom_app_bar.dart';
import 'package:bootstrap/ui/components/custom_bottom_navigation_bar.dart';
import 'package:bootstrap/ui/views/try_staggered_animation/steps/number_step.dart';
import 'package:bootstrap/ui/views/try_staggered_animation/steps/sms_step.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'try_staggered_animation_viewmodel.dart';

/*
title e subtitle - aparecem priemeiro
seta de voltar da appbar, aparece logo depois
textfield do numero - logo depois
primeiro botao - aparece logo depois


primeiro a primeira column
dps o field
dps o resend
 */

class TryStaggeredAnimationView
    extends StackedView<TryStaggeredAnimationViewModel> {
  const TryStaggeredAnimationView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    TryStaggeredAnimationViewModel viewModel,
    Widget? child,
  ) {
    Widget buildStep(SignupStep step) {
      switch (step) {
        case SignupStep.number:
          return const NumberStep(
              //key: const ValueKey('form'),
              //onNext: viewModel.goToSms,
              );

        case SignupStep.sms:
          return const SmsStep(
              // key: const ValueKey('sms'),
              // onNext: viewModel.goToLocation,
              // onBack: viewModel.back,
              );
      }
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'aa',
        widget: GestureDetector(
          onTap: viewModel.reset,
          child: const Icon(
            Icons.reset_tv,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: _AnimatedBottomBar(
        currentStep: viewModel.currentStep,
        onPressed: viewModel.next,
      ),
      body: Column(
        children: [
          //todo: back button com opacidade?
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: buildStep(viewModel.currentStep.value),
          ),
        ],
      ),
    );
  }

  @override
  TryStaggeredAnimationViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      TryStaggeredAnimationViewModel();
}

class _AnimatedBottomBar extends StatefulWidget {
  final ValueNotifier<SignupStep> currentStep;
  final VoidCallback onPressed;

  const _AnimatedBottomBar({
    required this.currentStep,
    required this.onPressed,
  });

  @override
  State<_AnimatedBottomBar> createState() => _AnimatedBottomBarState();
}

class _AnimatedBottomBarState extends State<_AnimatedBottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  static const _delay = Duration(milliseconds: 500);
  static const _duration = Duration(milliseconds: 600);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _duration);

    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCirc,
    );

    _fade = curved;
    _slide = Tween(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(curved);

    widget.currentStep.addListener(_onStepChanged);

    // Animate in on first entry (number step), delayed to sync with stagger
    Future.delayed(_delay, () {
      if (mounted) _controller.forward();
    });
  }

  void _onStepChanged() {
    if (widget.currentStep.value == SignupStep.number) {
      // Back to number: re-run animation after the AnimatedSwitcher fades in
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _controller.forward(from: 0);
      });
    }
    // sms step: button stays exactly as it is — no change
  }

  @override
  void dispose() {
    widget.currentStep.removeListener(_onStepChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: CustomBottonNavigationBar(
          widget: AppButton(
            text: 'Próximo',
            onPressed: widget.onPressed,
          ),
        ),
      ),
    );
  }
}
