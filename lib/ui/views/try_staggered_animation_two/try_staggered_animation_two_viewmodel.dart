import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.router.dart';
import 'package:bootstrap/ui/views/try_staggered_animation_two/steps/get_started_step_two/animations.dart';
import 'package:bootstrap/ui/views/try_staggered_animation_two/steps/number_step_two/animations.dart';
import 'package:bootstrap/ui/views/try_staggered_animation_two/steps/profile_step_two/animations.dart';
import 'package:bootstrap/ui/views/try_staggered_animation_two/steps/sms_step_two/animations.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

enum SignupStepTwo { getStarted, number, sms, profile }

class TryStaggeredAnimationTwoViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  SignupStepTwo currentStep = SignupStepTwo.getStarted;
  SignupStepTwo? previousStep;

  bool _isTransitioning = false;
  bool get isTransitioning => _isTransitioning;

  bool _initialized = false;
  final Curve _curve = Curves.easeOutCirc;

  // Step animation objects
  final getStartedAnimations = GetStartedStepTwoAnimations();
  final numberAnimations = NumberStepTwoAnimations();
  final smsAnimations = SmsStepTwoAnimations();
  final profileAnimations = ProfileStepTwoAnimations();

  // Shared: bottom button (number/sms steps)
  late AnimationController _buttonController;
  late Animation<double> buttonFade;
  late Animation<Offset> buttonSlide;

  // Shared: uniform fade-out for exiting step content
  late AnimationController _exitController;
  late Animation<double> contentOpacity;

  void init(TickerProvider vsync) {
    if (_initialized) return;
    _initialized = true;

    getStartedAnimations.setup(vsync, _curve);
    numberAnimations.setup(vsync, _curve);
    smsAnimations.setup(vsync, _curve);
    profileAnimations.setup(vsync, _curve);

    _buttonController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    buttonFade = CurvedAnimation(parent: _buttonController, curve: _curve);
    buttonSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _buttonController, curve: _curve));

    _exitController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 100),
    );
    contentOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeOut),
    );

    getStartedAnimations.run();
  }

  // GetStarted → number
  void next() async {
    if (_isTransitioning) return;

    switch (currentStep) {
      case SignupStepTwo.getStarted:
        _isTransitioning = true;

        previousStep = currentStep;
        currentStep = SignupStepTwo.number;
        numberAnimations.controller.value = 0;
        notifyListeners();

        final exitFutureGs = _exitController.forward(from: 0);
        numberAnimations.run();
        await exitFutureGs;

        _isTransitioning = false;
        previousStep = null;
        _exitController.reset();
        notifyListeners();

        Future.delayed(
          const Duration(milliseconds: 100),
          () => _buttonController.forward(from: 0),
        );
        break;

      case SignupStepTwo.number:
        _isTransitioning = true;

        previousStep = currentStep;
        currentStep = SignupStepTwo.sms;
        smsAnimations.controller.value = 0;
        notifyListeners();

        final exitFutureN = _exitController.forward(from: 0);
        smsAnimations.run();
        await exitFutureN;

        _isTransitioning = false;
        previousStep = null;
        _exitController.reset();
        notifyListeners();
        break;

      case SignupStepTwo.sms:
        _isTransitioning = true;

        previousStep = currentStep;
        currentStep = SignupStepTwo.profile;
        profileAnimations.controller.value = 0;
        notifyListeners();

        final exitFutureS = _exitController.forward(from: 0);
        _buttonController.reverse();
        profileAnimations.run();
        await exitFutureS;

        _isTransitioning = false;
        previousStep = null;
        _exitController.reset();
        notifyListeners();
        break;

      case SignupStepTwo.profile:
        break;
    }
  }

  Future<void> runBackToGetStarted() async {
    if (_isTransitioning) return;
    _isTransitioning = true;

    previousStep = currentStep;
    currentStep = SignupStepTwo.getStarted;
    getStartedAnimations.controller.value = 0;
    notifyListeners();

    final exitFuture = _exitController.forward(from: 0);
    _buttonController.reverse();
    getStartedAnimations.run();
    await exitFuture;

    _isTransitioning = false;
    previousStep = null;
    _exitController.reset();
    notifyListeners();
  }

  Future<void> runBackToNumber() async {
    if (_isTransitioning) return;
    _isTransitioning = true;

    previousStep = currentStep;
    currentStep = SignupStepTwo.number;
    numberAnimations.controller.value = 0;
    notifyListeners();

    final exitFuture = _exitController.forward(from: 0);
    numberAnimations.run();
    await exitFuture;

    _isTransitioning = false;
    previousStep = null;
    _exitController.reset();
    notifyListeners();
  }

  Future<void> runBackToSms() async {
    if (_isTransitioning) return;
    _isTransitioning = true;

    previousStep = currentStep;
    currentStep = SignupStepTwo.sms;
    smsAnimations.controller.value = 0;
    notifyListeners();

    final exitFuture = _exitController.forward(from: 0);
    _buttonController.forward(from: 0);
    smsAnimations.run();
    await exitFuture;

    _isTransitioning = false;
    previousStep = null;
    _exitController.reset();
    notifyListeners();
  }

  void back() {
    switch (currentStep) {
      case SignupStepTwo.getStarted:
        break;
      case SignupStepTwo.number:
        runBackToGetStarted();
        break;
      case SignupStepTwo.sms:
        runBackToNumber();
        break;
      case SignupStepTwo.profile:
        runBackToSms();
        break;
    }
  }

  void closeProfile() {
    back();
  }

  void finishProfile() {
    // TODO: navigate to next screen
  }

  void stopAllAnimations() {
    if (!_initialized) return;
    getStartedAnimations.stop();
    numberAnimations.stop();
    smsAnimations.stop();
    profileAnimations.stop();
    _buttonController.stop();
    _exitController.stop();
  }

  void reset() {
    _navigationService.clearStackAndShow(Routes.tryStaggeredAnimationTwoView);
  }

  @override
  void dispose() {
    if (_initialized) {
      getStartedAnimations.dispose();
      numberAnimations.dispose();
      smsAnimations.dispose();
      profileAnimations.dispose();
      _buttonController.dispose();
      _exitController.dispose();
    }
    super.dispose();
  }
}
