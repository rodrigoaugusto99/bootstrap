import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:stacked_services/stacked_services.dart';

class ConnectivityService {
  ValueNotifier<bool> hasInternet = ValueNotifier(false);

  StreamSubscription<InternetStatus>? _subscription;
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?
      _snackbarController;

  void init() {
    _initInternetListener();
  }

  Future<bool> hasInternetConnectivity() async {
    return await InternetConnection().hasInternetAccess;
  }

  void _initInternetListener() {
    _subscription =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      if (status == InternetStatus.connected) {
        hasInternet.value = true;
        _hideNoInternetSnackbar();
      } else {
        hasInternet.value = false;
        _showNoInternetSnackbar();
      }
    });
  }

  void _showNoInternetSnackbar() {
    final context = StackedService.navigatorKey?.currentContext;
    if (context == null) return;

    _snackbarController?.close();

    _snackbarController = ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.wifi_off,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: 14),
            Text(
              'Sem conexão com a internet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black87,
        duration: Duration(days: 365),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _hideNoInternetSnackbar() {
    _snackbarController?.close();
    _snackbarController = null;
  }

  void reset() {
    _hideNoInternetSnackbar();
    _subscription?.cancel();
  }
}
