import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.router.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

enum SignupStepTwo { number, sms }

class TryStaggeredAnimationTwoViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  SignupStepTwo currentStep = SignupStepTwo.number;
  bool _isTransitioning = false;

  // Controllers
  late AnimationController _numberController;
  late AnimationController _smsController;
  late AnimationController _buttonController;
  late AnimationController _exitController;

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

  // Button animation (lives in parent view, animates only on first entry)
  late Animation<double> buttonFade;
  late Animation<Offset> buttonSlide;

  // Fade-out uniforme do conteúdo de saída durante a transição.
  // Vai de 1.0 → 0.0 enquanto o controller avança.
  late Animation<double> contentOpacity;

  SignupStepTwo? previousStep;
  bool get isTransitioning => _isTransitioning;

  bool _initialized = false;
  final Curve _curve = Curves.easeOutCirc;

  void init(TickerProvider vsync) {
    if (_initialized) return;
    _initialized = true;

    _numberController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1000),
    );
    _smsController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 900),
    );
    _buttonController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    // Fade-out rápido e uniforme para todas as transições de saída
    _exitController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 100),
    );

    _setupNumberAnimations();
    _setupSmsAnimations();
    _setupButtonAnimation();
    _setupExitAnimation();
    runInitialNumberAnimation();
  }

  void runInitialNumberAnimation() {
    runNumberAnimations();
// Botão entra logo depois do campo de telefone, quase no mesmo
    Future.delayed(const Duration(milliseconds: 100), () {
      runButtonAnimation();
    });
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
    // opacity 1.0 quando controller=0, opacity 0.0 quando controller=1
    contentOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeOut),
    );
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

  // Sms → number: inicia o fade-out do SMS e a animação de entrada do number
  // ao mesmo tempo, sem esperar um terminar para começar o outro.
  Future<void> runBackToNumber() async {
    if (_isTransitioning) return;
    _isTransitioning = true;

    previousStep = currentStep; // sms
    currentStep = SignupStepTwo.number;
    _numberController.value = 0;
    notifyListeners(); // Stack: sms (saindo) + number (entrando)

    final exitFuture = _exitController.forward(from: 0);
    runNumberAnimations(); // começa junto com o fade-out
    await exitFuture;

    _isTransitioning = false;
    previousStep = null;
    _exitController.reset();
    notifyListeners();
  }

  // Number → sms: inicia o fade-out do number e a animação de entrada do sms
  // ao mesmo tempo, sem esperar um terminar para começar o outro.
  void next() async {
    if (_isTransitioning) return;

    switch (currentStep) {
      case SignupStepTwo.number:
        _isTransitioning = true;

        previousStep = currentStep; // number
        currentStep = SignupStepTwo.sms;
        _smsController.value = 0;
        notifyListeners(); // Stack: number (saindo) + sms (entrando)

        final exitFuture = _exitController.forward(from: 0);
        runSmsAnimations(); // começa junto com o fade-out
        await exitFuture;

        _isTransitioning = false;
        previousStep = null;
        _exitController.reset();
        notifyListeners();
        break;

      case SignupStepTwo.sms:
        finish();
        break;
    }
  }

  void back() {
    if (currentStep == SignupStepTwo.sms) {
      runBackToNumber();
    }
  }

  void finish() {
    // TODO: navigate to next screen
  }

  void reset() {
    _navigationService.clearStackAndShow(Routes.tryStaggeredAnimationTwoView);
  }

  @override
  void dispose() {
    if (_initialized) {
      _numberController.dispose();
      _smsController.dispose();
      _buttonController.dispose();
      _exitController.dispose();
    }
    super.dispose();
  }
}
