import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

BuildContext? getContext() {
  final context = StackedService.navigatorKey?.currentContext;

  return context;
}
