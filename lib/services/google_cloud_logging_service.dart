import 'dart:io';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis/logging/v2.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:logger/logger.dart';
import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/services/auth_service.dart';

class GoogleCloudLoggingService {
  final _serviceAccountCredentialsInternal = {};

  final _serviceAccountCredentialsStable = {};

  late final _projectId = DEVELOPMENT
      ? (_serviceAccountCredentialsInternal['project_id'] ?? "")
      : (_serviceAccountCredentialsStable['project_id'] ?? "");

  LoggingApi? _loggingApi;

  Future<void> setupLoggingApi() async {
    if (_loggingApi != null) return;
    final log = getLogger('GoogleCloudLoggingService');
    try {
      final credentials = ServiceAccountCredentials.fromJson(DEVELOPMENT
          ? _serviceAccountCredentialsInternal
          : _serviceAccountCredentialsStable);

      final authClient = await clientViaServiceAccount(
        credentials,
        [LoggingApi.loggingWriteScope],
      );

      _loggingApi = LoggingApi(authClient);
      log.i('Cloud Logging API setup complete');
    } catch (error) {
      log.e('Error setting up Cloud Logging API $error');
    }
  }

  void writeLog({required Level level, required String message}) {
    if (_loggingApi == null) {
      return;
    }

    final authService = locator<AuthService>();

    const env = DEVELOPMENT ? 'dev' : 'prod';
    final logName = 'projects/$_projectId/logs/$env';
    final platform = kIsWeb ? 'web' : Platform.operatingSystem;

    final resource = MonitoredResource()..type = 'global';

    // Map log levels to severity levels
    final severityFromLevel = switch (level) {
      Level.wtf => 'CRITICAL',
      Level.error => 'ERROR',
      Level.warning => 'WARNING',
      Level.info => 'INFO',
      Level.debug => 'DEBUG',
      _ => 'NOTICE',
    };

    // Create a log entry
    final logEntry = LogEntry()
      ..logName = logName
      ..jsonPayload = {'message': message}
      ..resource = resource
      ..severity = severityFromLevel
      ..labels = {
        'project_id': _projectId,
        'level': level.name.toUpperCase(),
        'environment': env,
        'user_id': authService.currUser?.uid ?? "",
        'app_name': 'topEntregas',
        'platform': platform,
      };
    final request = WriteLogEntriesRequest()..entries = [logEntry];

    _loggingApi!.entries.write(request).catchError((error) {
      print('Error writing log entry $error');
      return WriteLogEntriesResponse();
    });
  }
}
