import 'package:loader_overlay/loader_overlay.dart';
import 'package:bootstrap/utils/get_context.dart';

void showLoading() {
  final context = getContext();
  context!.loaderOverlay.show();
}

void hideLoading() {
  final context = getContext();
  context!.loaderOverlay.hide();
}
