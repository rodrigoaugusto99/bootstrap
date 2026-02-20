import 'package:bootstrap/utils/image_util.dart';
import 'package:bootstrap/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap/utils/enums.dart';
import 'package:bootstrap/utils/redirect_user.dart';
import 'package:bootstrap/utils/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class OnBoardingViewModel extends BaseViewModel {
  OnBoardingViewModel() {
    init();
  }
  final pageController = PageController();
  final animationDuration = const Duration(seconds: 1);

  int currentPage = 0;
  bool isLastPage = false;

  void init() async {
    pageController.addListener(() {
      int nextPage = pageController.page!.round();
      if (currentPage != nextPage) {
        currentPage = nextPage;
        isLastPage = currentPage == dataList.length - 1;
        notifyListeners();
      }
    });
  }

  List dataList = [
    {
      "title": "TITULO 1",
      "subtitle": "SUBTITULO 1",
      "image": ImageEnum.onBoarding1.assetPath,
    },
    {
      "title": "TITULO 2",
      "subtitle": "SUBTITULO 2",
      "image": ImageEnum.onBoarding2.assetPath,
    },
    {
      "title": "TITULO 3",
      "subtitle": "SUBTITULO 3",
      "image": ImageEnum.onBoarding3.assetPath,
    }
  ];

  void jumpPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  Future<void> nextPage() async {
    if (isLastPage) {
      showLoading();
      await setBoolSharedPreferences(
        key: SharedPreferencesKeys.sawOnboarding,
        value: true,
      );
      RedirectUser().redirectUser();
      return;
    }
    pageController.nextPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  Future<void> backPage() {
    if (currentPage == 0) return Future.value();
    return pageController.previousPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }
}
