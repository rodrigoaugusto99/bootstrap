import 'dart:io';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/exceptions/app_error.dart';
import 'package:bootstrap/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _log = getLogger('uploadFile');

String? _getContentType(String path) {
  final extension = path.split('.').last.toLowerCase();
  switch (extension) {
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'gif':
      return 'image/gif';
    case 'bmp':
      return 'image/bmp';
    case 'webp':
      return 'image/webp';
    case 'pdf':
      return 'application/pdf';
    default:
      return null;
  }
}

Future<String> uploadFile({
  required File file,
  required String fileName,
  required String userId,
  required String path,
}) async {
  try {
    final prefix = '$path/$userId/$fileName';
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child('$prefix.jpg');
    final contentType = _getContentType(file.path);

    // Uploading the file
    UploadTask uploadTask = imageRef.putFile(
      file,
      SettableMetadata(
        contentType: contentType,
      ),
    );

    // Await the completion of the upload
    await uploadTask;

    // Get the download URL
    String downloadURL = await imageRef.getDownloadURL();
    //_log.i('File uploaded successfully. Download URL: $downloadURL');
    return downloadURL;
  } on Exception catch (e) {
    _log.e('Error uploading file: $e');
    throw AppError(message: 'Erro ao processar imagem');
  }
}

Future<List<String>> uploadFiles({
  required List<File> files,
  required String userId,
  required String path,
}) async {
  for (var file in files) {
    if (await isFileLargerThan5MB(file)) {
      _log.e('File is larger than 5 MB');
      throw AppError(
          message: 'Não é permitido enviar arquivos maiores que 5 MB');
    }
  }
  //final List<String> urls = [];
  try {
    final uploadTasks = files.map((file) async {
      final random = DateTime.now().millisecondsSinceEpoch +
          (1000 * files.indexOf(file)) +
          (DateTime.now().microsecondsSinceEpoch % 1000);
      final url = await uploadFile(
        path: path,
        file: file,
        fileName: 'photo_$random',
        userId: userId,
      );
      return url;
    }).toList();
    final urls = await Future.wait(uploadTasks);
    //_log.i('Files uploaded successfully. URLs: $urls');
    return urls;
  } on Exception catch (e) {
    _log.e('Error uploading files: $e');
    rethrow;
  }
}
