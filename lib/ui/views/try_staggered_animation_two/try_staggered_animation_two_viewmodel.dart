import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.router.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

enum SignupStepTwo { getStarted, number, sms, profile }

class TryStaggeredAnimationTwoViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  SignupStepTwo currentStep = SignupStepTwo.getStarted;
  bool _isTransitioning = false;

  // Controllers
  late AnimationController _getStartedController;
  late AnimationController _numberController;
  late AnimationController _smsController;
  late AnimationController _profileController;
  late AnimationController _buttonController;
  late AnimationController _exitController;

  // GetStarted step — logo animations
  late Animation<double> logoFade;
  late Animation<double> logoScale;
  late Animation<double> logoAlignProgress; // 0.0 = center, 1.0 = top

  // GetStarted step — content animations
  late Animation<double> getStartedTitleFade;
  late Animation<Offset> getStartedTitleSlide;
  late Animation<double> getStartedPhoneFade;
  late Animation<Offset> getStartedPhoneSlide;
  late Animation<double> getStartedOrFade;
  late Animation<Offset> getStartedOrSlide;
  late Animation<double> getStartedAppleFade;
  late Animation<Offset> getStartedAppleSlide;
  late Animation<double> getStartedGoogleFade;
  late Animation<Offset> getStartedGoogleSlide;
  late Animation<double> getStartedTermsFade;
  late Animation<Offset> getStartedTermsSlide;

  // Number step animations
  late Animation<double> numberTitleFade;
  late Animation<Offset> numberTitleSlide;
  late Animation<double> numberFieldFade;
  late Animation<Offset> numberFieldSlide;

  // SMS step animations
  late Animation<double> smsTitleFade;
  late Animation<Offset> smsTitleSlide;
  late Animation<double> smsPinFade;
  late Animation<Offset> smsPinSlide;
  late Animation<double> smsResendFade;
  late Animation<Offset> smsResendSlide;

  // Profile step animations
  late Animation<double> profileCloseFade;
  late Animation<Offset> profileCloseSlide;
  late Animation<double> profileTitleFade;
  late Animation<Offset> profileTitleSlide;
  late Animation<double> profileNameRowFade;
  late Animation<Offset> profileNameRowSlide;
  late Animation<double> profileEmailFade;
  late Animation<Offset> profileEmailSlide;
  late Animation<double> profileButtonInsideFade;
  late Animation<Offset> profileButtonInsideSlide;
  late Animation<double> profileRichTextFade;
  late Animation<Offset> profileRichTextSlide;

  // Button animation (bottom nav, for number/sms steps)
  late Animation<double> buttonFade;
  late Animation<Offset> buttonSlide;

  // Uniform fade-out for exiting step content: 1.0 → 0.0
  late Animation<double> contentOpacity;

  SignupStepTwo? previousStep;
  bool get isTransitioning => _isTransitioning;

  bool _initialized = false;
  final Curve _curve = Curves.easeOutCirc;

  void init(TickerProvider vsync) {
    if (_initialized) return;
    _initialized = true;

    // GetStarted: logo wait (~500ms) + logo fly (~500ms) + content cascade (~780ms)
    _getStartedController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2000),
    );
    _numberController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1000),
    );
    _smsController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2000),
    );
    _profileController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2000),
    );
    _buttonController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    _exitController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 100),
    );

    _setupGetStartedAnimations();
    _setupNumberAnimations();
    _setupSmsAnimations();
    _setupProfileAnimations();
    _setupButtonAnimation();
    _setupExitAnimation();

    runGetStartedAnimations();
  }

  // GetStarted animation timing (duration 2000ms):
  // logo fade in   : 0ms–140ms   → interval(0.00, 0.07)
  // logo stays big : 140ms–500ms (no animation, just visible)
  // logo fly+shrink: 500ms–1000ms → interval(0.25, 0.50)
  // title          : 1040ms–1280ms → interval(0.52, 0.64)
  // phone btn      : 1140ms–1380ms → interval(0.57, 0.69)
  // "or"           : 1240ms–1480ms → interval(0.62, 0.74)
  // apple btn      : 1340ms–1580ms → interval(0.67, 0.79)
  // google btn     : 1440ms–1680ms → interval(0.72, 0.84)
  // terms          : 1540ms–1780ms → interval(0.77, 0.89)
  void _setupGetStartedAnimations() {
    logoFade = CurvedAnimation(
      parent: _getStartedController,
      curve: const Interval(0.00, 0.07, curve: Curves.easeOut),
    );

    // logoScale and logoAlignProgress share the same curved sub-animation
    // so the logo moves and shrinks in perfect sync.
    final logoMoveCurve = CurvedAnimation(
      parent: _getStartedController,
      curve: Interval(0.25, 0.50, curve: Curves.easeInOutCubic),
    );
    logoScale = Tween<double>(begin: 1.0, end: 0.4).animate(logoMoveCurve);
    logoAlignProgress = logoMoveCurve;

    getStartedTitleFade = CurvedAnimation(
      parent: _getStartedController,
      curve: Interval(0.52, 0.64, curve: _curve),
    );
    getStartedTitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _getStartedController,
      curve: Interval(0.52, 0.64, curve: _curve),
    ));

    getStartedPhoneFade = CurvedAnimation(
      parent: _getStartedController,
      curve: Interval(0.57, 0.69, curve: _curve),
    );
    getStartedPhoneSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _getStartedController,
      curve: Interval(0.57, 0.69, curve: _curve),
    ));

    getStartedOrFade = CurvedAnimation(
      parent: _getStartedController,
      curve: Interval(0.62, 0.74, curve: _curve),
    );
    getStartedOrSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _getStartedController,
      curve: Interval(0.62, 0.74, curve: _curve),
    ));

    getStartedAppleFade = CurvedAnimation(
      parent: _getStartedController,
      curve: Interval(0.67, 0.79, curve: _curve),
    );
    getStartedAppleSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _getStartedController,
      curve: Interval(0.67, 0.79, curve: _curve),
    ));

    getStartedGoogleFade = CurvedAnimation(
      parent: _getStartedController,
      curve: Interval(0.72, 0.84, curve: _curve),
    );
    getStartedGoogleSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _getStartedController,
      curve: Interval(0.72, 0.84, curve: _curve),
    ));

    getStartedTermsFade = CurvedAnimation(
      parent: _getStartedController,
      curve: Interval(0.77, 0.89, curve: _curve),
    );
    getStartedTermsSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _getStartedController,
      curve: Interval(0.77, 0.89, curve: _curve),
    ));
  }

  void _setupNumberAnimations() {
    numberTitleFade = CurvedAnimation(
      parent: _numberController,
      curve: Interval(0.0, 0.55, curve: _curve),
    );
    numberTitleSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _numberController,
      curve: Interval(0.0, 0.55, curve: _curve),
    ));

    numberFieldFade = CurvedAnimation(
      parent: _numberController,
      curve: Interval(0.1, 0.7, curve: _curve),
    );
    numberFieldSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _numberController,
      curve: Interval(0.1, 0.7, curve: _curve),
    ));
  }

  void _setupSmsAnimations() {
    smsTitleFade = CurvedAnimation(
      parent: _smsController,
      curve: Interval(0.0, 0.5, curve: _curve),
    );
    smsTitleSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _smsController,
      curve: Interval(0.0, 0.5, curve: _curve),
    ));

    smsPinFade = CurvedAnimation(
      parent: _smsController,
      curve: Interval(0.1, 0.7, curve: _curve),
    );
    smsPinSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _smsController,
      curve: Interval(0.1, 0.7, curve: _curve),
    ));

    smsResendFade = CurvedAnimation(
      parent: _smsController,
      curve: Interval(0.2, 0.75, curve: _curve),
    );
    smsResendSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _smsController,
      curve: Interval(0.2, 0.75, curve: _curve),
    ));
  }

  // Profile step: close icon + title appear quickly first, then after ~500ms
  // the rest cascades in.
  //
  // Duration: 2000ms
  // close icon : 0ms–200ms    → interval(0.00, 0.10)
  // title      : 100ms–300ms  → interval(0.05, 0.15)
  // [~500ms gap]
  // name row   : 800ms–1000ms → interval(0.40, 0.50)
  // email      : 900ms–1100ms → interval(0.45, 0.55)
  // button     : 1000ms–1200ms → interval(0.50, 0.60)
  // rich text  : 1100ms–1300ms → interval(0.55, 0.65)
  void _setupProfileAnimations() {
    profileCloseFade = CurvedAnimation(
      parent: _profileController,
      curve: Interval(0.00, 0.10, curve: _curve),
    );
    profileCloseSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _profileController,
      curve: Interval(0.00, 0.10, curve: _curve),
    ));

    profileTitleFade = CurvedAnimation(
      parent: _profileController,
      curve: Interval(0.05, 0.15, curve: _curve),
    );
    profileTitleSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _profileController,
      curve: Interval(0.05, 0.15, curve: _curve),
    ));

    profileNameRowFade = CurvedAnimation(
      parent: _profileController,
      curve: Interval(0.40, 0.50, curve: _curve),
    );
    profileNameRowSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _profileController,
      curve: Interval(0.40, 0.50, curve: _curve),
    ));

    profileEmailFade = CurvedAnimation(
      parent: _profileController,
      curve: Interval(0.45, 0.55, curve: _curve),
    );
    profileEmailSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _profileController,
      curve: Interval(0.45, 0.55, curve: _curve),
    ));

    profileButtonInsideFade = CurvedAnimation(
      parent: _profileController,
      curve: Interval(0.50, 0.60, curve: _curve),
    );
    profileButtonInsideSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _profileController,
      curve: Interval(0.50, 0.60, curve: _curve),
    ));

    profileRichTextFade = CurvedAnimation(
      parent: _profileController,
      curve: Interval(0.55, 0.65, curve: _curve),
    );
    profileRichTextSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _profileController,
      curve: Interval(0.55, 0.65, curve: _curve),
    ));
  }

  void _setupButtonAnimation() {
    buttonFade = CurvedAnimation(
      parent: _buttonController,
      curve: _curve,
    );
    buttonSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: _curve,
    ));
  }

  void _setupExitAnimation() {
    contentOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeOut),
    );
  }

  void runGetStartedAnimations() {
    _getStartedController.forward(from: 0);
  }

  void runNumberAnimations() {
    _numberController.forward(from: 0);
  }

  void runButtonAnimation() {
    _buttonController.forward(from: 0);
  }

  void runSmsAnimations() {
    _smsController.forward(from: 0);
  }

  void runProfileAnimations() {
    _profileController.forward(from: 0);
  }

  // GetStarted → number
  void next() async {
    if (_isTransitioning) return;

    switch (currentStep) {
      case SignupStepTwo.getStarted:
        _isTransitioning = true;

        previousStep = currentStep;
        currentStep = SignupStepTwo.number;
        _numberController.value = 0;
        notifyListeners();

        final exitFutureGs = _exitController.forward(from: 0);
        runNumberAnimations();
        await exitFutureGs;

        _isTransitioning = false;
        previousStep = null;
        _exitController.reset();
        notifyListeners();

        Future.delayed(const Duration(milliseconds: 100), runButtonAnimation);
        break;

      case SignupStepTwo.number:
        _isTransitioning = true;

        previousStep = currentStep;
        currentStep = SignupStepTwo.sms;
        _smsController.value = 0;
        notifyListeners();

        final exitFutureN = _exitController.forward(from: 0);
        runSmsAnimations();
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
        _profileController.value = 0;
        notifyListeners();

        final exitFutureS = _exitController.forward(from: 0);
        _buttonController.reverse();
        runProfileAnimations();
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

    previousStep = currentStep; // number
    currentStep = SignupStepTwo.getStarted;
    notifyListeners();

    final exitFuture = _exitController.forward(from: 0);
    _buttonController.reverse();
    await exitFuture;

    _isTransitioning = false;
    previousStep = null;
    _exitController.reset();
    notifyListeners();
  }

  Future<void> runBackToNumber() async {
    if (_isTransitioning) return;
    _isTransitioning = true;

    previousStep = currentStep; // sms
    currentStep = SignupStepTwo.number;
    _numberController.value = 0;
    notifyListeners();

    final exitFuture = _exitController.forward(from: 0);
    runNumberAnimations();
    await exitFuture;

    _isTransitioning = false;
    previousStep = null;
    _exitController.reset();
    notifyListeners();
  }

  void back() {
    switch (currentStep) {
      case SignupStepTwo.getStarted:
        _navigationService.back();
        break;
      case SignupStepTwo.number:
        runBackToGetStarted();
        break;
      case SignupStepTwo.sms:
        runBackToNumber();
        break;
      case SignupStepTwo.profile:
        break;
    }
  }

  void closeProfile() {
    _navigationService.back();
  }

  void finishProfile() {
    // TODO: navigate to next screen
  }

  void reset() {
    _navigationService.clearStackAndShow(Routes.tryStaggeredAnimationTwoView);
  }

  @override
  void dispose() {
    if (_initialized) {
      _getStartedController.dispose();
      _numberController.dispose();
      _smsController.dispose();
      _profileController.dispose();
      _buttonController.dispose();
      _exitController.dispose();
    }
    super.dispose();
  }
}
