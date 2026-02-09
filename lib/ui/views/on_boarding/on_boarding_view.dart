import 'package:bootstrap/utils/helpers.dart';
import 'package:bootstrap/utils/image_util.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap/ui/common/app_colors.dart';
import 'package:bootstrap/ui/components/app_button.dart';
import 'package:stacked/stacked.dart';
import 'on_boarding_viewmodel.dart';

class OnBoardingView extends StackedView<OnBoardingViewModel> {
  const OnBoardingView({super.key});

  @override
  Widget builder(
    BuildContext context,
    OnBoardingViewModel viewModel,
    Widget? child,
  ) {
    precacheImage(AssetImage(ImageEnum.onBoarding1.assetPath), context);
    precacheImage(AssetImage(ImageEnum.onBoarding2.assetPath), context);
    precacheImage(AssetImage(ImageEnum.onBoarding3.assetPath), context);

    Widget positioned(int index) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        color: Colors.white,
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              viewModel.dataList[index]["title"],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              viewModel.dataList[index]["subtitle"],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        await viewModel.backPage();
        return false;
      },
      child: Scaffold(
        body: PageView.builder(
          controller: viewModel.pageController,
          itemCount: viewModel.dataList.length,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Stack(
                  children: [
                    Image.asset(
                      viewModel.dataList[index]["image"],
                      fit: BoxFit.fitWidth,
                    ),
                    // const Positioned(
                    //   bottom: 0,
                    //   left: 0,
                    //   right: 0,
                    //   child: ImageUtil(
                    //     ImageEnum.blur,
                    //   ),
                    // ),
                  ],
                ),
                Positioned(
                  //top: 0,
                  left: 0,
                  right: 0,
                  bottom: 40,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      positioned(index),
                      // const Positioned(
                      //   top: -49,
                      //   left: 0,
                      //   right: 0,
                      //   child: ImageUtil(
                      //     ImageEnum.blur,
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
        // extendBody: true,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              NavigationBarWidget(
                listPages: viewModel.dataList,
                onTap: (index) => viewModel.jumpPage(index),
                currentPage: viewModel.currentPage,
              ),
              const SizedBox(height: 24),
              AppButton(
                onPressed: viewModel.nextPage,
                text: 'Continuar',
                backgroundColor: kcPrimaryColor,
              ),
              SizedBox(height: getBottomPadding(context) + 32),
            ],
          ),
        ),
      ),
    );
  }

  @override
  OnBoardingViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      OnBoardingViewModel();
}

class NavigationBarWidget extends StatelessWidget {
  final List listPages;
  final Function(int) onTap;
  final int currentPage;

  const NavigationBarWidget({
    super.key,
    required this.listPages,
    required this.onTap,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: listPages.map((item) {
        int index = listPages.indexOf(item);
        return InkWell(
          onTap: () => onTap(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 10),
            width: 24,
            height: 8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: currentPage == index
                    ? const Color(0xff728792)
                    : const Color(0xffCED7DD)),
          ),
        );
      }).toList(),
    );
  }
}
