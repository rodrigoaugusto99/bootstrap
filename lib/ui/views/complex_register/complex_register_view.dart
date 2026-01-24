import 'package:bootstrap/ui/views/complex_register/pages/first_page.dart';
import 'package:bootstrap/ui/views/complex_register/pages/second_page.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'complex_register_viewmodel.dart';

class ComplexRegisterView extends StackedView<ComplexRegisterViewModel> {
  const ComplexRegisterView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ComplexRegisterViewModel viewModel,
    Widget? child,
  ) {
    return WillPopScope(
      onWillPop: () async {
        viewModel.back();
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        // appBar: AppBarWidget(
        //   title: 'Cadastre-se',
        //   canGoBack: true,
        //   onBack: viewModel.back,
        //   hasLogout: true,
        // ),
        //extendBody: true,
        // bottomNavigationBar: CustomBottonNavigationBar(
        //   text: viewModel.buttonText,
        //   onPressed: viewModel.nextPage,
        // ),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                //clipBehavior: Clip.none,
                physics: const NeverScrollableScrollPhysics(),
                controller: viewModel.pageController,
                children: [
                  FirstPage(viewModel: viewModel),
                  SecondPage(viewModel: viewModel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  ComplexRegisterViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ComplexRegisterViewModel();
}
