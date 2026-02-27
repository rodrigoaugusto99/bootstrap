import 'dart:io';
import 'dart:math' as math;
import 'package:bootstrap/utils/get_context.dart';
import 'package:bootstrap/utils/image_util.dart';
import 'package:bootstrap/utils/svg_util.dart';
import 'package:bootstrap/utils/toast.dart';
import 'package:bootstrap/utils/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

//todo: parametro de pré-mensagem
Future<void> sendWppMessage(String? number, {String? message}) async {
  if (number == null) {
    throw Exception('Número não disponível');
  }
  final numb = removeSpecialCaracteres(number);
  String whatsappUrl = 'https://api.whatsapp.com/send?phone=55$numb';

  if (message != null) {
    final formattedMessage = Uri.encodeComponent(message);
    whatsappUrl = "$whatsappUrl&text=$formattedMessage";
  }

  try {
    openUrl(whatsappUrl);
  } on Exception {
    AppToast.showToast(text: "Não foi possível abrir o WhatsApp");
  }
}

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

String gerarCpfValido({bool comPontuacao = false}) {
  final random = math.Random();

  // Gera os 9 primeiros dígitos
  final List<int> cpf = List.generate(9, (_) => random.nextInt(10));

  // Calcula o primeiro dígito verificador
  int soma1 = 0;
  for (int i = 0; i < 9; i++) {
    soma1 += cpf[i] * (10 - i);
  }
  int digito1 = 11 - (soma1 % 11);
  if (digito1 >= 10) digito1 = 0;

  cpf.add(digito1);

  // Calcula o segundo dígito verificador
  int soma2 = 0;
  for (int i = 0; i < 10; i++) {
    soma2 += cpf[i] * (11 - i);
  }
  int digito2 = 11 - (soma2 % 11);
  if (digito2 >= 10) digito2 = 0;

  cpf.add(digito2);

  final cpfString = cpf.join();

  if (!comPontuacao) {
    return cpfString;
  }

  // Formata: XXX.XXX.XXX-XX
  return '${cpfString.substring(0, 3)}.'
      '${cpfString.substring(3, 6)}.'
      '${cpfString.substring(6, 9)}-'
      '${cpfString.substring(9)}';
}
