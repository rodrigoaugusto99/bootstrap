import 'dart:async';

import 'package:bootstrap/utils/app_session.dart';
import 'package:bootstrap/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/logging/v2.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:logger/logger.dart';

// Manda os logs do app para o Cloud Logging do projeto (só em release: ver GCPLogger).
// 🔥 OBRIGATÓRIO em todo app: não remover (docs/novo-app, etapa 3).
//
// A chave é da conta de serviço <nome-interno>-logs, que tem UM papel só: Gravador de
// registros (roles/logging.logWriter). Ela vai dentro do app de propósito (decisão de
// 27/09/2026): quem extrair a chave do APK só consegue escrever log. Nenhuma outra
// chave de conta de serviço pode entrar no app.
//
// Os logs saem em lote (a cada 5 segundos, ou 20 linhas, ou quando o app vai para o
// fundo), cada linha com uid, sessão, versão e plataforma como labels. No console:
// Logs Explorer → logName="projects/<project-id>/logs/app" e labels.user_id="<uid>".
class GoogleCloudLoggingService {
  GoogleCloudLoggingService._();
  static final instance = GoogleCloudLoggingService._();

  // Cole aqui o JSON da chave da conta <nome-interno>-logs de cada projeto (IAM →
  // Contas de serviço → <nome-interno>-logs → Chaves → Adicionar chave → JSON).
  // Vazio, nada é enviado. App com um projeto só: o mesmo JSON nos dois.
  static const Map<String, dynamic> _serviceAccountCredentialsInternal = {};
  static const Map<String, dynamic> _serviceAccountCredentialsStable = {};

  static const _credentials = DEVELOPMENT
      ? _serviceAccountCredentialsInternal
      : _serviceAccountCredentialsStable;

  static const _logName = 'app';
  static const _flushEvery = Duration(seconds: 5);
  static const _batchSize = 20;
  static const _maxBuffer = 500;

  final List<LogEntry> _buffer = [];
  LoggingApi? _api;
  String _projectId = '';
  Future<void>? _setup;
  Timer? _timer;

  bool get _configured => _credentials.isNotEmpty;

  Future<void> setupLoggingApi() {
    if (!_configured) return Future.value();
    return _setup ??= _connect();
  }

  Future<void> _connect() async {
    try {
      _projectId = _credentials['project_id'] as String? ?? '';
      final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(_credentials),
        [LoggingApi.loggingWriteScope],
      );
      _api = LoggingApi(client);
      _timer ??= Timer.periodic(_flushEvery, (_) => flush());
      unawaited(flush());
    } catch (_) {
      // Sem rede na abertura: tenta de novo no próximo log.
      _setup = null;
    }
  }

  void writeLog({required Level level, required String message}) {
    if (!_configured) return;
    if (_buffer.length >= _maxBuffer) _buffer.removeAt(0);
    _buffer.add(LogEntry()
      ..severity = _severity(level)
      ..timestamp = DateTime.now().toUtc().toIso8601String()
      ..jsonPayload = {'message': message}
      ..labels = {
        'user_id': FirebaseAuth.instance.currentUser?.uid ?? '',
        'session_id': AppSession.id,
        'app_version': AppSession.version,
        'platform': AppSession.platform,
        'environment': DEVELOPMENT ? 'dev' : 'prod',
        'level': level.name.toUpperCase(),
      });
    if (_api == null) {
      unawaited(setupLoggingApi());
    } else if (_buffer.length >= _batchSize) {
      unawaited(flush());
    }
  }

  // Também chamar quando o app vai para o fundo, para não perder o fim da sessão.
  Future<void> flush() async {
    final api = _api;
    if (api == null || _buffer.isEmpty) return;
    final entries = List<LogEntry>.of(_buffer);
    _buffer.clear();
    try {
      await api.entries.write(WriteLogEntriesRequest()
        ..logName = 'projects/$_projectId/logs/$_logName'
        ..resource = (MonitoredResource()..type = 'global')
        ..labels = {'app_name': logAppName}
        ..entries = entries);
    } catch (_) {
      // Falhou (sem rede): as linhas voltam para a fila. Não dá para logar aqui.
      final room = (_maxBuffer - _buffer.length).clamp(0, _maxBuffer);
      _buffer.insertAll(0, entries.take(room));
    }
  }

  static String _severity(Level level) => switch (level) {
        Level.wtf => 'CRITICAL',
        Level.error => 'ERROR',
        Level.warning => 'WARNING',
        Level.info => 'INFO',
        _ => 'DEBUG',
      };
}
