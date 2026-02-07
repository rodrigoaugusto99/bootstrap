import 'dart:async';

import 'package:bootstrap/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/*
  VIEW:

PinCodeField(
    fieldHeight: acessibilityEnabled(context) ? 80 : 44,
    fieldWidth: acessibilityEnabled(context) ? 80 : 44,
    onCompleted: (value) {
      viewModel.onCompleted(value);
    },
    errorAnimationController: viewModel.errorAnimationController,
  ),

  VIEWMODEL:

  late final StreamController<ErrorAnimationType> errorAnimationController;

  void init() {
    errorAnimationController = StreamController<ErrorAnimationType>();
  }

  - para lançar erro:

  errorAnimationController.add(ErrorAnimationType.shake);
 */

class PinCodeField extends StatelessWidget {
  final Function(String) onCompleted;
  final StreamController<ErrorAnimationType>? errorAnimationController;
  final int length;
  final double fieldHeight;
  final double fieldWidth;
  const PinCodeField({
    super.key,
    required this.onCompleted,
    required this.errorAnimationController,
    this.length = 6,
    this.fieldHeight = 46,
    this.fieldWidth = 44,
  });

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      // backgroundColor: Colors.red,
      mainAxisAlignment: MainAxisAlignment.center,
      separatorBuilder: (c, index) => const SizedBox(width: 8),
      length: length, enableActiveFill: true,
      obscureText: false,
      animationType: AnimationType.scale,
      animationCurve: Curves.easeInOutQuad,
      keyboardType: TextInputType.number,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        fontFamily: 'Montserrat',
      ),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      pinTheme: PinTheme(
        errorBorderColor: Colors.red[300],
        shape: PinCodeFieldShape.box,
        borderWidth: 11,
        borderRadius: BorderRadius.circular(8),
        fieldHeight: fieldHeight,
        fieldWidth: fieldWidth,
        activeColor: const Color(0xff185365),
        selectedColor: kcPrimaryColor,
        inactiveColor: const Color(0xffCBCBCB),
        disabledColor: Colors.black,
        activeFillColor: const Color(0xffF5F5F5),
        selectedFillColor: const Color(0xffF5F5F5),
        inactiveFillColor: const Color(0xffF5F5F5),
      ),
      animationDuration: const Duration(milliseconds: 100),
      errorAnimationController: errorAnimationController,

      //controller: viewModel.codeController,
      onCompleted: (String value) {
        onCompleted(value);
      },
      // onChanged: (value) {
      //   viewModel.onChanged(value);
      // },
      beforeTextPaste: (text) {
        print("Allowing to paste $text");
        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
        //but you can show anything you want here, like your pop up saying wrong paste format or etc
        return true;
      },
      appContext: context,
    );
  }
}
