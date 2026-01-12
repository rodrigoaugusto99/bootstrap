import 'dart:io';

import 'package:bootstrap/utils/get_context.dart';
import 'package:bootstrap/utils/image_util.dart';
import 'package:bootstrap/utils/svg_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

void unfocus() {
  final context = getContext();
  if (context != null) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}

void preCacheImages(
    BuildContext context, List<ImageEnum> images, List<SvgEnum> svgs) {
  for (var imageEnum in images) {
    precacheImage(AssetImage(imageEnum.assetPath), context);
  }
  for (var svgEnum in svgs) {
    final loader = SvgAssetLoader(svgEnum.assetPath);
    svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
  }
}
