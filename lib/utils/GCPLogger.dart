import 'package:logger/logger.dart';
import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/services/google_cloud_logging_service.dart';

class GCPLogger extends LogOutput {
  final _gcpLogger = locator<GoogleCloudLoggingService>();

  @override
  void output(OutputEvent event) {
    _gcpLogger.writeLog(level: event.level, message: event.lines.join('\n'));
  }
}
