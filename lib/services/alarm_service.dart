import 'package:just_audio/just_audio.dart';
import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/services/app_service.dart';

class AlarmService {
  final _log = getLogger('AlarmService');
  final _appService = locator<AppService>();
  final AudioPlayer _alarmAudioPlayer = AudioPlayer();
  final AudioPlayer _warningAudioPlayer = AudioPlayer();
  bool _isPlaying = false;

  Future<void> init() async {
    await _alarmAudioPlayer.setLoopMode(LoopMode.one);
    await _alarmAudioPlayer.setAsset('assets/sounds/toque.mp3');
    await _warningAudioPlayer.setAsset('assets/sounds/warning.mp3');
  }

  Future<void> startWarning() async {
    try {
      await _warningAudioPlayer.seek(Duration.zero);
      _warningAudioPlayer.play();
      _log.i('Warning started');
    } catch (e) {
      _log.e(e);
    }
  }

  Future<void> startAlarm({bool ignoreAppState = false}) async {
    try {
      if (_isPlaying) {
        return;
      }
      _isPlaying = true;
      await _alarmAudioPlayer.play();

      _log.i('Alarm started');
    } catch (e) {
      _log.e(e);
    }
  }

  Future<void> stopAlarm() async {
    try {
      if (!_isPlaying) {
        // _log.w('Alarm not playing');
        return;
      }

      await _alarmAudioPlayer.stop();
      await _alarmAudioPlayer.seek(Duration.zero);
      _isPlaying = false;
      _log.i('Alarm stopped');
    } catch (e) {
      _log.e(e);
    }
  }
}
