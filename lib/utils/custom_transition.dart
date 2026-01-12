import 'package:flutter/material.dart';

/*

   - app.dart:

CustomRoute(
      page: HelpView,
      durationInMilliseconds: 800,
    ),

   - navegações

_navigationService.replaceWith(
      Routes.deliveryView,
      transition: transitionAnimation(),
    );


    _navigationService.navigateToHelpView(
      null,
      true,
      null,
      transitionAnimation(),
    );

    _navigationService.navigateToReportView(
      isCodeProblem: false,
      transition: transitionAnimation(),
    );
 */

Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transitionAnimation() {
  return (context, animation, secondaryAnimation, child) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.easeInOutCubicEmphasized;
    var curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
    return SlideTransition(
      position: Tween<Offset>(begin: begin, end: end).animate(curvedAnimation),
      child: child,
    );
  };
}
