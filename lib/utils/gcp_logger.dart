import 'package:logger/logger.dart';
import 'package:bootstrap/services/google_cloud_logging_service.dart';

// Saída do logger que manda cada linha para o Cloud Logging (só em release; em debug
// os logs vão para o console). Não depende do locator: loga desde a primeira linha
// do main.
class GCPLogger extends LogOutput {
  @override
  void output(OutputEvent event) {
    GoogleCloudLoggingService.instance.writeLog(
      level: event.level,
      message: event.lines.join('\n'),
    );
  }
}
