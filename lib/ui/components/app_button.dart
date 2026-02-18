import 'package:bootstrap/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap/ui/common/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? fontSize;
  final bool isBusy;
  final bool hasBorder;
  final bool enable;
  final String? fontFamily;
  final int? maxLines;
  final Color? superBackgroundColor;
  final Color? backgroundColorDisabled;
  final Color? textColorDisabled;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.borderColor,
    this.fontSize,
    this.fontFamily,
    this.textColor,
    this.hasBorder = false,
    this.isBusy = false,
    this.enable = true,
    this.backgroundColor = kcPrimaryColor,
    this.maxLines,
    this.superBackgroundColor,
    this.backgroundColorDisabled,
    this.textColorDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: key,
      onPressed: isBusy || !enable ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        side: hasBorder
            ? BorderSide(
                color: borderColor ?? kcPrimaryColor,
                width: 1,
              )
            : null,
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      child: isBusy
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: textColor ?? Colors.black,
                strokeWidth: 2,
              ),
            )
          : styledText(
              // textAlign: TextAlign.center,
              text: text,
              maxLines: maxLines,
              fontSize: fontSize ?? 16,
              fontFamily: fontFamily ?? 'Roboto',
              color: textColor,
            ),
    );
  }
}
