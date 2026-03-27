import 'dart:async';

import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/exceptions/app_error.dart';
import 'package:bootstrap/schemas/code_sent_schema.dart';
import 'package:bootstrap/schemas/verify_code_schema.dart';
import 'package:bootstrap/services/auth_service.dart';
import 'package:bootstrap/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stacked/stacked.dart';

class EnterCodeViewModel extends BaseViewModel {
  EnterCodeViewModel({
    required this.codeSentParams,
    required this.phoneNumber,
    required this.onVerified,
  }) {
    init();
  }

  final _authService = locator<AuthService>();
  //final _analyticsService = locator<AnalyticsService>();
  final String screenName = 'enter_code_screen';
  late final StreamController<ErrorAnimationType> errorAnimationController;

  final _log = getLogger('LoginViewModel');

  final formKey = GlobalKey<FormState>();

  final phoneController = TextEditingController();
  final codeController = TextEditingController();

  CodeSentParams? codeSentParams;
  final String phoneNumber;
  final Function() onVerified;
  void init() {
    focus();
    errorAnimationController = StreamController<ErrorAnimationType>();
    //verifyPhoneNumber();
    startTimer();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   focus();
    // });
  }

  FocusNode focusNode = FocusNode();

  void focus() {
    focusNode.requestFocus();
    notifyListeners();
  }

  Future<void> onCompleted(String code) async {
    // log.v('onCompleted');
    if (code.length != 6) {
      _log.e('Code is not valid');
      return;
    }
    showLoading();
    try {
      final params = VerifyCodeParams(
        verificationId: codeSentParams!.verificationId,
        smsCode: code,
      );
      await _authService.verifyCode(params);
      onVerified();
    } on AppError {
      hideLoading();
      errorAnimationController.add(ErrorAnimationType.shake);
    }

    //  log.i('Code is valid, calling callback');
  }

  Timer? timer;
  Timer? emailVerificationTimer;
  int secondsRemaining = 50;
  final log = getLogger('EnterCodeViewModel');

  bool isCounting = true;

  void startTimer() {
    isCounting = true;
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer timer) {
      if (secondsRemaining == 0) {
        isCounting = false;
        notifyListeners();
        timer.cancel();
      } else {
        secondsRemaining--;
        notifyListeners();
      }
    });
  }

  void resend() {
    log.v('resend');
    secondsRemaining = 50;
    startTimer();
    _authService.sendCode(
      phoneNumber: phoneNumber,
      resendToken: codeSentParams?.resendToken,
      onSent: (params) {
        // _analyticsService.logSMSCodeSent(
        //   screenName: 'enter_code_screen',
        // );
        codeSentParams = params;
        notifyListeners();
      },
      onError: (message) {
        log.e('Error resending code: $message');
        secondsRemaining = 0;
        isCounting = false;
        timer?.cancel();
        notifyListeners();
      },
    );
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    emailVerificationTimer?.cancel();
    // errorAnimationController.close();
    super.dispose();
  }
}
