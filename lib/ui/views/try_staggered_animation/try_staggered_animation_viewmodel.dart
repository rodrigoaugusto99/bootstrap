import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.router.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart' show NavigationService;

enum SignupStep {
  number,
  sms,
}

class TryStaggeredAnimationViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final currentStep = ValueNotifier<SignupStep>(SignupStep.number);

  // void goToSms() {
  //   currentStep.value = SignupStep.sms;
  // }

  // void goToLocation() {
  //   currentStep.value = SignupStep.location;
  // }

  void finish() {
    // TODO: navigate to next screen
  }

  void next() {
    switch (currentStep.value) {
      case SignupStep.number:
        currentStep.value = SignupStep.sms;
        notifyListeners();
        break;
      case SignupStep.sms:
        //currentStep.value = SignupStep.location;
        finish();
        break;
      // case SignupStep.location:
      //   finish();
      //   break;
    }
  }

  void back() {
    switch (currentStep.value) {
      case SignupStep.sms:
        currentStep.value = SignupStep.number;
        notifyListeners();
        break;
      // case SignupStep.location:
      //   currentStep.value = SignupStep.sms;
      //   break;
      default:
        break;
    }
  }

  void reset() {
    _navigationService.clearStackAndShow(Routes.tryStaggeredAnimationView);
  }

  @override
  void dispose() {
    super.dispose();
    currentStep.dispose();
  }
}
