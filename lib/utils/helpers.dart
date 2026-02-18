import 'dart:math' as math;
import 'package:bootstrap/ui/common/app_colors.dart';
import 'package:bootstrap/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

bool acessibilityEnabled(BuildContext context) {
  double scale = MediaQuery.of(context).textScaler.scale(1);
  return scale > 1.3;
}

Widget adaptiveRow({
  required BuildContext context,
  required List<Widget> children,
  bool considerAccessibility = true,
  MainAxisAlignment columnMainAxisAlignment = MainAxisAlignment.start,
  MainAxisAlignment rowMainAxisAlignment = MainAxisAlignment.start,
  CrossAxisAlignment columnCrossAxisAlignment = CrossAxisAlignment.center,
  CrossAxisAlignment rowCrossAxisAlignment = CrossAxisAlignment.center,
  MainAxisSize columnMainAxisSize = MainAxisSize.max,
  MainAxisSize rowMainAxisSize = MainAxisSize.max,
}) {
  final useColumn =
      considerAccessibility ? acessibilityEnabled(context) : false;

  return useColumn
      ? Column(
          mainAxisAlignment: columnMainAxisAlignment,
          crossAxisAlignment: columnCrossAxisAlignment,
          mainAxisSize: columnMainAxisSize,
          children: children,
        )
      : Row(
          mainAxisAlignment: rowMainAxisAlignment,
          crossAxisAlignment: rowCrossAxisAlignment,
          mainAxisSize: rowMainAxisSize,
          children: children,
        );
}

Widget columnAndRowAccessibility({
  bool isSingleWidget = false,
  required BuildContext context,
  required List<Widget> normalChildren,
  required List<Widget> accessibilityChildren,
  MainAxisAlignment accessibilityMainAxisAlignment = MainAxisAlignment.start,
  MainAxisAlignment normalMainAxisAlignment = MainAxisAlignment.start,
  CrossAxisAlignment accessibilityCrossAxisAlignment =
      CrossAxisAlignment.center,
  CrossAxisAlignment normalCrossAxisAlignment = CrossAxisAlignment.center,
  MainAxisSize accessibilityMainAxisSize = MainAxisSize.max,
  MainAxisSize normalMainAxisSize = MainAxisSize.max,
}) {
  final isAccessibilityEnabled = acessibilityEnabled(context);

  if (isSingleWidget) {
    return isAccessibilityEnabled
        ? accessibilityChildren.first
        : normalChildren.first;
  }

  return isAccessibilityEnabled
      ? Column(
          mainAxisAlignment: accessibilityMainAxisAlignment,
          crossAxisAlignment: accessibilityCrossAxisAlignment,
          mainAxisSize: accessibilityMainAxisSize,
          children: accessibilityChildren,
        )
      : Row(
          mainAxisAlignment: normalMainAxisAlignment,
          crossAxisAlignment: normalCrossAxisAlignment,
          mainAxisSize: normalMainAxisSize,
          children: normalChildren,
        );
}

Widget widthSeparator(double value) {
  return SizedBox(
    width: value,
  );
}

Widget heightSeparator(double value) {
  return SizedBox(
    height: value,
  );
}

Widget divider({
  Color? color,
  double? thickness,
  double? height,
}) =>
    Divider(
      color: color ?? Colors.grey,
      thickness: thickness ?? 1,
      height: height ?? 0,
    );

Widget decContainer({
  Clip? clipBehavior,
  double? radius,
  double? height,
  double? width,
  double? leftPadding,
  double? topPadding,
  double? rightPadding,
  double? bottomPadding,
  double? borderWidth,
  Color? color,
  Color? foregroundColor,
  Color? borderColor,
  double? allPadding,
  double? leftBorderWidth,
  double? topBorderWidth,
  double? rightBorderWidth,
  double? bottomBorderWidth,
  Color? leftBorderColor,
  Color? topBorderColor,
  Color? rightBorderColor,
  Color? bottomBorderColor,
  Widget? child,
  Function()? onTap,
  double? topLeftRadius,
  double? topRightRadius,
  double? bottomLeftRadius,
  double? bottomRightRadius,
  double? outLeftPadding,
  double? outTopPadding,
  double? outRightPadding,
  double? outBottomPadding,
  double? outAllPadding,
  List<BoxShadow>? boxShadow,
  EdgeInsetsGeometry? margin,
  Alignment? alignment,
  Gradient? gradient,
  Key? key,
  bool isCircle = false,
  double? circleSize,
  double? symetricHorizontalPadding,
  double? symetricVerticalPadding,
  double? outSymetricHorizontalPadding,
  double? outSymetricVerticalPadding,
  BoxConstraints? constraints,
}) {
  return GestureDetector(
    key: key,
    behavior: HitTestBehavior.translucent,
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.only(
        left: outLeftPadding ??
            outAllPadding ??
            outSymetricHorizontalPadding ??
            0,
        top: outTopPadding ?? outAllPadding ?? outSymetricVerticalPadding ?? 0,
        right: outRightPadding ??
            outAllPadding ??
            outSymetricHorizontalPadding ??
            0,
        bottom: outBottomPadding ??
            outAllPadding ??
            outSymetricVerticalPadding ??
            0,
      ),
      child: Container(
        constraints: constraints,
        alignment: alignment,
        margin: margin,
        clipBehavior: clipBehavior ?? Clip.antiAlias,
        foregroundDecoration: BoxDecoration(color: foregroundColor),
        padding: EdgeInsets.only(
          left: leftPadding ?? allPadding ?? symetricHorizontalPadding ?? 0,
          top: topPadding ?? allPadding ?? symetricVerticalPadding ?? 0,
          right: rightPadding ?? allPadding ?? symetricHorizontalPadding ?? 0,
          bottom: bottomPadding ?? allPadding ?? symetricVerticalPadding ?? 0,
        ),
        height: circleSize ?? height,
        width: circleSize ?? width,
        decoration: BoxDecoration(
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          boxShadow: boxShadow,
          color: color,
          gradient: gradient,
          border: borderWidth != null && borderColor != null
              ? Border.all(
                  width: borderWidth,
                  color: borderColor,
                )
              : Border(
                  left: BorderSide(
                    width: leftBorderWidth ?? borderWidth ?? 0,
                    color: leftBorderColor ?? borderColor ?? Colors.transparent,
                  ),
                  top: BorderSide(
                    width: topBorderWidth ?? borderWidth ?? 0,
                    color: topBorderColor ?? borderColor ?? Colors.transparent,
                  ),
                  right: BorderSide(
                    width: rightBorderWidth ?? borderWidth ?? 0,
                    color:
                        rightBorderColor ?? borderColor ?? Colors.transparent,
                  ),
                  bottom: BorderSide(
                    width: bottomBorderWidth ?? borderWidth ?? 0,
                    color:
                        bottomBorderColor ?? borderColor ?? Colors.transparent,
                  ),
                ),
          borderRadius: isCircle
              ? null
              : radius != null
                  ? BorderRadius.circular(radius)
                  : BorderRadius.only(
                      topLeft: Radius.circular(topLeftRadius ?? 0),
                      topRight: Radius.circular(topRightRadius ?? 0),
                      bottomLeft: Radius.circular(bottomLeftRadius ?? 0),
                      bottomRight: Radius.circular(bottomRightRadius ?? 0),
                    ),
        ),
        child: child,
      ),
    ),
  );
}

enum FontWeightEnum {
  regular,
  medium,
  semiBold,
  bold,
}

Widget styledText({
  required String text,
  double? fontSize,
  FontWeightEnum? fontWeightEnum,
  FontWeight? fontWeight,
  Color? color,
  Color? decorationColor,
  TextDecoration? decoration,
  double? height,
  TextAlign? textAlign,
  bool? showShimmer,
  double? shimmerRadius,
  double? shimmerWidth,
  bool hasOverflow = false,
  bool shimmerWithoutOpacity = false,
  Function()? onTap,
  double? decorationThickness,
  int? maxLines,
  double? letterSpacing,
  bool isSegoe = false,
  bool isBold = false,
  String? fontFamily,
  Key? key,
  Key? keyText,
  TextOverflow? overflow,
}) {
  final textStyle = TextStyle(
    letterSpacing: letterSpacing ?? 0.0,
    overflow: overflow ?? (hasOverflow ? TextOverflow.ellipsis : null),
    fontSize: fontSize,
    color: color ?? kcTextColor,
    decoration: decoration,
    decorationColor: color ?? decorationColor,
    decorationThickness: decorationThickness,
    height: height,
    fontWeight: fontWeightEnum != null
        ? switch (fontWeightEnum) {
            FontWeightEnum.regular => FontWeight.w400,
            FontWeightEnum.medium => FontWeight.w500,
            FontWeightEnum.semiBold => FontWeight.w600,
            FontWeightEnum.bold => FontWeight.w700,
          }
        : isBold
            ? FontWeight.bold
            : fontWeight,
    fontFamily: isSegoe ? 'Segoe UI' : fontFamily,
  );

  return GestureDetector(
    key: key,
    onTap: showShimmer != null && showShimmer ? null : onTap,
    onLongPress: DEVELOPMENT
        ? () => _showTextDebugInfo(
              text: text,
              textStyle: textStyle,
            )
        : null,
    child: Text(
      key: keyText,
      maxLines: maxLines,
      text,
      style: textStyle,
      textAlign: textAlign,
    ),
  );
}

double getBottomPadding(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);

  final bottomPadding = math.max(
    mediaQuery.viewInsets.bottom,
    mediaQuery.viewPadding.bottom,
  );
  return bottomPadding;
}

class AppRichText extends StatelessWidget {
  final List<TextSpan> children;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final double? textScaleFactor;

  const AppRichText({
    super.key,
    required this.children,
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(
      color: kcTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: 'Montserrat',
      height: 1.4,
    );

    return RichText(
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      text: TextSpan(
        style: style,
        children: children,
      ),
      textScaler: TextScaler.linear(
          textScaleFactor ?? MediaQuery.of(context).textScaleFactor),
    );
  }
}

class MappedColumn<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(T item, int index) itemBuilder;
  final double spacing;
  final Widget? separator;
  final Widget? lastItemSeparator;
  final double lastItemSpacing;

  const MappedColumn({
    Key? key,
    required this.items,
    required this.itemBuilder,
    this.spacing = 0,
    this.separator,
    this.lastItemSeparator,
    this.lastItemSpacing = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.asMap().entries.map((entry) {
        final item = entry.value;
        final index = entry.key;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            itemBuilder(item, index),
            if (index != items.length - 1)
              separator ?? heightSeparator(spacing),
            if (index == items.length - 1)
              lastItemSeparator ?? heightSeparator(spacing),
          ],
        );
      }).toList(),
    );
  }
}

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double screenWidthFraction(BuildContext context,
        {int dividedBy = 1, double offsetBy = 0, double max = 3000}) =>
    math.min((screenWidth(context) - offsetBy) / dividedBy, max);

double getResponsiveSmallFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 14, max: 15);

double getResponsiveMediumFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 16, max: 17);

double getResponsiveLargeFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 21, max: 31);

double getResponsiveExtraLargeFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 25);

double getResponsiveMassiveFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 30);

double getResponsiveFontSize(BuildContext context,
    {double? fontSize, double? max}) {
  max ??= 100;

  var responsiveSize = math.min(
      screenWidthFraction(context, dividedBy: 10) * ((fontSize ?? 100) / 100),
      max);

  return responsiveSize;
}

const double figmaHeight = 812;
const double figmaWidth = 375;

double getResponsiveHeight(BuildContext context, double height) {
  return (height / figmaHeight) * screenHeight(context);
}

double getResponsiveWidth(BuildContext context, double width) {
  return (width / figmaWidth) * screenWidth(context);
}

void _showTextDebugInfo({
  required String text,
  required TextStyle textStyle,
}) {
  final context = StackedService.navigatorKey?.currentContext;
  if (context == null) return;

  final fontSize = textStyle.fontSize ?? 14.0;
  final fontFamily = textStyle.fontFamily ?? 'Maven Pro';
  final fontWeight = textStyle.fontWeight ?? FontWeight.normal;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Informações do Texto'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Texto: "$text"',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Font Size: $fontSize',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            'Font Family: $fontFamily',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            'Font Weight: ${_fontWeightToString(fontWeight)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar'),
        ),
      ],
    ),
  );
}

String _fontWeightToString(FontWeight fontWeight) {
  switch (fontWeight) {
    case FontWeight.w100:
      return 'w100 (Thin)';
    case FontWeight.w200:
      return 'w200 (ExtraLight)';
    case FontWeight.w300:
      return 'w300 (Light)';
    case FontWeight.w400:
      return 'w400 (Normal)';
    case FontWeight.w500:
      return 'w500 (Medium)';
    case FontWeight.w600:
      return 'w600 (SemiBold)';
    case FontWeight.w700:
      return 'w700 (Bold)';
    case FontWeight.w800:
      return 'w800 (ExtraBold)';
    case FontWeight.w900:
      return 'w900 (Black)';
    default:
      return 'w400 (Normal)';
  }
}
