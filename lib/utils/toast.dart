import 'package:bootstrap/utils/get_context.dart';
import 'package:bootstrap/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

enum ToastType { success, error, warning }

class AppToast {
  static ToastFuture? showToast({
    ToastType type = ToastType.error,
    required String text,
    String? subText,
    double? height,
    StyledToastPosition? position,
    StyledToastAnimation? fromWhere,
    StyledToastAnimation? reverseTo,
    bool showIcon = true,
  }) {
    BuildContext? context = getContext();

    return showToastWidget(
      decContainer(
        width: double.infinity,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
        outTopPadding: getResponsiveWidth(context!, 12),
        radius: 12,
        outLeftPadding: getResponsiveWidth(context, 32),
        outRightPadding: getResponsiveWidth(context, 32),
        outBottomPadding:
            getBottomPadding(context) + getResponsiveWidth(context, 62),
        color: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              styledText(
                text: text,
                color: Colors.black,
                fontFamily: "Roboto",
                fontSize: 14,
              ),
              if (subText != null) ...[
                heightSeparator(4),
                styledText(
                  text: subText,
                  color: Colors.black,
                  fontFamily: "Roboto",
                  fontSize: 12,
                ),
              ],
            ],
          ),
        ),
      ),
      animation: fromWhere ?? StyledToastAnimation.slideFromBottom,
      position: position ?? StyledToastPosition.bottom,
      animDuration: const Duration(milliseconds: 600),
      reverseAnimation: reverseTo ?? StyledToastAnimation.slideToBottom,
      duration: const Duration(seconds: 3),
      curve: Curves.easeInOutCubicEmphasized,
      reverseCurve: Curves.easeInOutCubicEmphasized,
      dismissOtherToast: true,
    );
  }
}
