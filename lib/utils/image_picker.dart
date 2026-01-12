/*
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:instrutor_direcao/app/app.logger.dart';

final _log = getLogger('ImagePicker');
Future<File?> pickMedia() async {
  final picker = ImagePicker();

  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

Future<File?> pickFromCamera() async {
  final picker = ImagePicker();

  final pickedFile = await picker.pickImage(source: ImageSource.camera);

  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

Future<File?> retrieveLostImage() async {
  final picker = ImagePicker();
  final LostDataResponse response = await picker.retrieveLostData();

  if (response.isEmpty) {
    _log.w('retrieveLostImage - nenhum arquivo perdido encontrado');
    return null;
  }

  if (response.file != null) {
    return File(response.file!.path);
  }
  _log.w('nada encontrado');
  return null;
}

 */
