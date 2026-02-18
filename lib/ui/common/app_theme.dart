import 'package:bootstrap/ui/common/app_colors.dart';
import 'package:flutter/material.dart';

ThemeData makeAppTheme() {
  return ThemeData(
    visualDensity: VisualDensity.standard,
    useMaterial3: true,
    primaryColor: kcPrimaryColor,
    fontFamily: "Poppins",
    appBarTheme: const AppBarTheme(
      backgroundColor: kcPrimaryColor,
      foregroundColor: Colors.white,
    ),
    primarySwatch: Colors.cyan,
    scaffoldBackgroundColor: Colors.white,
  );
}
