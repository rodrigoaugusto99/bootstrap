import 'package:bootstrap/utils/helpers.dart';
import 'package:flutter/material.dart';

class CustomBottonNavigationBar extends StatefulWidget {
  final String? text;
  final Function()? onPressed;
  final Widget? widget;
  const CustomBottonNavigationBar({
    super.key,
    this.onPressed,
    this.widget,
    this.text,
  });

  @override
  State<CustomBottonNavigationBar> createState() =>
      _CustomBottonNavigationBarState();
}

class _CustomBottonNavigationBarState extends State<CustomBottonNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: getBottomPadding(context) + 32,
        top: 4,
        left: 24,
        right: 24,
      ),
      child: widget.widget,
    );
  }
}
