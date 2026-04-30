import 'package:share_plus/share_plus.dart';

Future<void> shareText(String text, {String? subject}) async {
  await SharePlus.instance.share(ShareParams(text: text, subject: subject));
}

Future<void> shareFile(
  String filePath, {
  String? text,
  String? subject,
}) async {
  await SharePlus.instance.share(ShareParams(
    files: [XFile(filePath)],
    text: text,
    subject: subject,
  ));
}

Future<void> shareFiles(
  List<String> filePaths, {
  String? text,
  String? subject,
}) async {
  await SharePlus.instance.share(ShareParams(
    files: filePaths.map((p) => XFile(p)).toList(),
    text: text,
    subject: subject,
  ));
}

Future<ShareResultStatus> shareTextWithResult(
  String text, {
  String? subject,
}) async {
  final result = await SharePlus.instance
      .share(ShareParams(text: text, subject: subject));
  return result.status;
}

Future<ShareResultStatus> shareFileWithResult(
  String filePath, {
  String? text,
  String? subject,
}) async {
  final result = await SharePlus.instance.share(ShareParams(
    files: [XFile(filePath)],
    text: text,
    subject: subject,
  ));
  return result.status;
}

Future<void> shareUri(Uri uri) async {
  await SharePlus.instance.share(ShareParams(uri: uri));
}
