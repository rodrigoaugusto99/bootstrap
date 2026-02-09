import 'package:bootstrap/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap/ui/common/app_colors.dart';
import 'package:bootstrap/utils/enums.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? fontSize;
  final double? height;
  final double? symmetricHorizontalPadding;
  final FontWeightEnum? fontWeightEnum;
  final bool isBusy;
  final bool hasBorder;
  final bool enable;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final int? maxLines;
  final Color? superBackgroundColor;
  final double? opacityTextColor;
  final Color? backgroundColorDisabled;
  final Color? textColorDisabled;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.borderColor,
    this.fontWeightEnum = FontWeightEnum.bold,
    this.fontSize,
    this.fontFamily,
    this.textColor,
    this.hasBorder = false,
    this.height,
    this.fontWeight,
    this.isBusy = false,
    this.enable = true,
    this.backgroundColor = kcPrimaryColor,
    this.maxLines,
    this.superBackgroundColor,
    this.opacityTextColor,
    this.backgroundColorDisabled,
    this.textColorDisabled,
    this.symmetricHorizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 56,
        minWidth: 0,
      ),
      child: ElevatedButton(
        key: key,
        onPressed: isBusy || !enable ? null : onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, 56),
          padding: symmetricHorizontalPadding != null
              ? EdgeInsets.symmetric(horizontal: symmetricHorizontalPadding!)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: hasBorder
              ? BorderSide(color: borderColor ?? kcPrimaryColor, width: 1)
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
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: styledText(
                  text: text,
                  maxLines: maxLines,
                  fontSize: fontSize ?? 16,
                  fontWeightEnum: fontWeightEnum,
                  fontFamily: fontFamily ?? 'Montserrat',
                  color: textColor,
                ),
              ),
      ),
    );
  }
}
