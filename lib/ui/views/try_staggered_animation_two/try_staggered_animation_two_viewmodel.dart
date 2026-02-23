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

  // Fade-out uniforme do conteúdo atual antes de trocar de step.
  // Vai de 1.0 → 0.0 enquanto o controller avança.
  late Animation<double> contentOpacity;

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
      duration: const Duration(milliseconds: 220),
    );

    _setupNumberAnimations();
    _setupSmsAnimations();
    _setupButtonAnimation();
    _setupExitAnimation();

    runNumberAnimations();
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

  // Fade-out uniforme do conteúdo atual, depois reseta para o próximo step.
  Future<void> _fadeOutContent() async {
    await _exitController.forward(from: 0);
    _exitController.reset(); // volta para opacity 1.0 antes do próximo rebuild
  }

  // Stagger de entrada do número. Chamado SOMENTE na entrada inicial da tela.
  // O botão também anima aqui e nunca mais.
  void runNumberAnimations() {
    _numberController.forward(from: 0);
    // Botão entra logo depois do campo de telefone, quase no mesmo tempo
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_initialized) return;
      _buttonController.forward(from: 0);
    });
  }

  // Stagger de entrada do SMS.
  // O botão NÃO é tocado — permanece visível exatamente como está.
  void runSmsAnimations() {
    _smsController.forward(from: 0);
  }

  // Fade-out uniforme do SMS, depois mostra o número.
  // Botão NÃO re-anima — já está visível e fica parado.
  // O conteúdo de number já está com _numberController em 1.0,
  // então aparece diretamente sem precisar re-animar.
  Future<void> runBackToNumber() async {
    if (_isTransitioning) return;
    _isTransitioning = true;

    await _fadeOutContent();

    currentStep = SignupStepTwo.number;
    notifyListeners();

    _isTransitioning = false;
  }

  void next() async {
    if (_isTransitioning) return;

    switch (currentStep) {
      case SignupStepTwo.number:
        _isTransitioning = true;

        // Fade-out do conteúdo do number enquanto prepara o SMS
        await _fadeOutContent();

        currentStep = SignupStepTwo.sms;
        notifyListeners();

        // _smsController começa do zero para o stagger entrar do início
        _smsController.value = 0;
        runSmsAnimations();

        _isTransitioning = false;
        break;

      case SignupStepTwo.sms:
        finish();
        break;
    }
  }

  void back() {
    runBackToNumber();
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
