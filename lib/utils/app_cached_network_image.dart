import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/utils/helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Toda imagem remota do app passa por aqui. 🔥 OBRIGATÓRIO: não remover.
// App com muitas imagens imutáveis (catálogo, conteúdo): passe um cacheManager com
// limite alto e prazo longo — o padrão do flutter_cache_manager é 200 objetos/30 dias.
final _log = getLogger('AppCachedNetworkImage');

Widget appCachedNetWorkImage({
  String? imageUrl,
  double? height,
  double? width,
  BoxFit? fit,
  bool isCircle = false,
  double? radius,
  Function()? onTap,
}) {
  if (imageUrl == null || imageUrl == '') {
    return const SizedBox();
  }

  return decContainer(
    isCircle: isCircle,
    radius: radius,
    child: GestureDetector(
      onTap: onTap,
      child: CachedNetworkImage(
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        imageUrl: imageUrl,
        placeholder: (context, url) {
          return Skeletonizer(
            enabled: true,
            child: Skeleton.leaf(
              child: decContainer(
                isCircle: true,
                color: Colors.red,
              ),
            ),
          );
        },
        errorWidget: (context, url, error) {
          _log.w('Imagem não carregou: $url ($error)');
          return const Icon(Icons.error);
        },
      ),
    ),
  );
}
