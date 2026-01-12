import 'package:url_launcher/url_launcher.dart';

void openUrl(String url) async {
  if (await canOpenUrl(url)) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

Future<bool> canOpenUrl(String url) async {
  return await canLaunchUrl(Uri.parse(url));
}

Future<void> openUrlWithFallback(
  String url, {
  required String fallbackUrl,
}) async {
  if (await canOpenUrl(url)) {
    openUrl(url);
  } else {
    openUrl(fallbackUrl);
  }
}
