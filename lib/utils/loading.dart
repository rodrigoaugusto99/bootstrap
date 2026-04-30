import 'package:bootstrap/app/app.logger.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:bootstrap/utils/get_context.dart';

final _log = getLogger('Loading');

void showLoading(String text) {
  _log.wtf('showLoading: $text');
  final context = getContext();
  if (context!.loaderOverlay.visible) return;
  context.loaderOverlay.show();
}

void hideLoading(String text) {
  _log.wtf('hideLoading: $text');
  final context = getContext();
  context!.loaderOverlay.hide();
}
