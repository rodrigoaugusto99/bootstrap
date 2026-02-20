import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';

void openUrl(String url) async {
  bool canOpen = await canOpenUrl(url);
  if (!canOpen) {
    throw 'Could not launch $url';
  }
  if (url.contains("mailto:")) {
    FlutterEmailSender.send(Email(
      recipients: [url.replaceAll("mailto:", "")],
    ));
  }
  await launchUrl(Uri.parse(url));
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
