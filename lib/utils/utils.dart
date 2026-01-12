import 'dart:io';

Future<bool> isFileLargerThan5MB(File file) async {
  int fileSizeInBytes = await file.length();
  double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
  return fileSizeInMB > 5;
}

// PARA USAR NO FIREBASE AUTH SMS
String convertPhoneNumber(String? phoneNumber) {
  return '+55${removeSpecialCaracteres(phoneNumber)}';
}

String removeSpecialCaracteres(String? text) {
  if (text == null) {
    return '';
  }
  return text.replaceAll(RegExp(r'[^\d]'), '');
}
