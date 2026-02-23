import 'package:bootstrap/ui/components/app_button.dart';
import 'package:bootstrap/ui/components/custom_app_bar.dart';
import 'package:bootstrap/ui/components/custom_bottom_navigation_bar.dart';
import 'package:bootstrap/ui/views/try_staggered_animation_two/steps/number_step_two.dart';
import 'package:bootstrap/ui/views/try_staggered_animation_two/steps/sms_step_two.dart';
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
    // _AnimatedContent é StatefulWidget para fornecer TickerProvider ao ViewModel.
    // O Flutter preserva o State entre rebuilds (mesmo tipo, sem key diferente),
    // então initState() só é chamado uma vez mesmo que notifyListeners() rebuilde a view.
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
    // Passa o TickerProvider para o ViewModel criar os AnimationControllers
    widget.viewModel.init(this);
  }

  @override
  void didUpdateWidget(_AnimatedContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Só re-inicializa se o ViewModel mudar de instância (ex: após reset)
    if (oldWidget.viewModel != widget.viewModel) {
      widget.viewModel.init(this);
    }
  }

  Widget _buildStep() {
    switch (widget.viewModel.currentStep) {
      case SignupStepTwo.number:
        return NumberStepTwo(viewModel: widget.viewModel);
      case SignupStepTwo.sms:
        return SmsStepTwo(viewModel: widget.viewModel);
    }
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
        bottomNavigationBar: FadeTransition(
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
        ),
        body: Column(
          children: [
            // contentOpacity faz o fade-out uniforme do conteúdo atual
            // antes de trocar o step. O próximo step entra via suas próprias animações.
            FadeTransition(
              opacity: vm.contentOpacity,
              child: _buildStep(),
            ),
          ],
        ),
      ),
    );
  }
}
