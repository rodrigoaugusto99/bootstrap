import 'dart:async';

import 'package:bootstrap/ui/views/startup/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';
import 'package:bootstrap/ui/common/ui_helpers.dart';

import 'startup_viewmodel.dart';

class StartupView extends StackedView<StartupViewModel> {
  StartupView({Key? key}) : super(key: key);
  final Completer<void> animationCompleter = Completer<void>();
  @override
  Widget builder(
    BuildContext context,
    StartupViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      //backgroundColor: Colors.orange,
      body: Splash(
        animationCompleter: animationCompleter,
      ),
    );
  }

  @override
  StartupViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      StartupViewModel(context: context);

  @override
  void onViewModelReady(StartupViewModel viewModel) =>
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) => viewModel
          .runStartupLogic(animationCompleted: animationCompleter.future));
}
