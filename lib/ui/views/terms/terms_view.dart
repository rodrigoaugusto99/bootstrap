import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'terms_viewmodel.dart';

class TermsView extends StackedView<TermsViewModel> {
  const TermsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    TermsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("TermsView")),
      ),
    );
  }

  @override
  TermsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      TermsViewModel();
}
