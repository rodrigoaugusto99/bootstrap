import 'package:bootstrap/app/app.bottomsheets.dart';
import 'package:bootstrap/app/app.locator.dart';
import 'package:flutter/material.dart';

import 'package:stacked_services/stacked_services.dart';
import '../ui/bottom_sheets/notice/notice_sheet.dart';

void setupBottomSheetUiWithCustomAnimations() {
  final bottomsheetService = locator<BottomSheetService>();

  final Map<BottomSheetType, SheetBuilder> builders = {
    BottomSheetType.notice: (context, request, completer) =>
        _CustomAnimatedBottomSheet(
          child: NoticeSheet(request: request, completer: completer),
        ),
  };

  bottomsheetService.setCustomSheetBuilders(builders);
}

class _CustomAnimatedBottomSheet extends StatefulWidget {
  final Widget child;

  const _CustomAnimatedBottomSheet({required this.child});

  @override
  State<_CustomAnimatedBottomSheet> createState() =>
      _CustomAnimatedBottomSheetState();
}

class _CustomAnimatedBottomSheetState extends State<_CustomAnimatedBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 3),
      //begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubicEmphasized,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubicEmphasized,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //return widget.child;
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        alignment: Alignment.bottomCenter,
        child: widget.child,
      ),
    );
  }
}
