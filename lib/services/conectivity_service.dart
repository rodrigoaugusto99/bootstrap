import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class ConnectivityService {
  ValueNotifier<bool> hasInternet = ValueNotifier(false);

  StreamSubscription<List<ConnectivityResult>>? subscription;
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?
      _snackbarController;

  void init() {
    initInternetListener();
  }

  Future<bool> hasInternetConnectivity() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    }
    return false;
  }

  void initInternetListener() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {
      if (result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile)) {
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
        // margin: EdgeInsets.only(
        //   bottom: MediaQuery.of(context).size.height - 150,
        //   left: 10,
        //   right: 10,
        // ),
      ),
    );
  }

  void _hideNoInternetSnackbar() {
    _snackbarController?.close();
    _snackbarController = null;
  }

  void reset() {
    _hideNoInternetSnackbar();
    subscription?.cancel();
  }
}
