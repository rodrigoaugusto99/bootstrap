import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/services/api_service.dart';
import 'package:bootstrap/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:logger/logger.dart';

class LogarteOutput extends LogOutput {
  static Logarte? _logarteInstance;

  static void setLogarteInstance(Logarte logarte) {
    _logarteInstance = logarte;
  }

  @override
  void output(OutputEvent event) {
    if (_logarteInstance != null) {
      // Enviar apenas logs de erro (Level.error e Level.fatal)
      // if (event.level == Level.error || event.level == Level.fatal) {

      // }
      final message = event.lines.join('\n');
      _logarteInstance!.log(message);
    }
  }
}

class LogarteService {
  final Logarte logarte = Logarte(
    // Protect with password
    // password: '1234',

    // Skip password in debug mode
    //  ignorePassword: kDebugMode,
    ignorePassword: true,

    // Share network request
    onShare: (String content) {
      //Share.share(content);
    },

    // Desabilita logs no console do IDE (apenas mostra na página do Logarte)
    disableDebugConsoleLogs: true,

    // Add shortcut actions (optional)
    onRocketLongPressed: (context) {
      // e.g: toggle theme mode
    },
    onRocketDoubleTapped: (context) {
      // e.g: change language
    },
  );
  void init(BuildContext context) {
    if (!DEVELOPMENT) return;
    initApiServiceInterceptor();

    logarte.attach(
      context: context,
      visible: true,
    );

    // Configurar a instância do Logarte no sistema de logging
    LogarteOutput.setLogarteInstance(logarte);
  }

  void initApiServiceInterceptor() {
    locator<ApiService>().dio.interceptors.add(LogarteDioInterceptor(logarte));
  }
}
