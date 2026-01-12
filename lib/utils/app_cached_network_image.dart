import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget appCachedNetWorkImage({
  String? imageUrl,
  double? height,
  double? width,
  BoxFit? fit,
  bool isRounded = false,
  double? radius,
  Function()? onTap,
}) {
  if (imageUrl == null || imageUrl == '') {
    const SizedBox();
  }

  return GestureDetector(
    onTap: onTap,
    child: CachedNetworkImage(
      height: height,
      width: width,
      fit: BoxFit.cover,
      imageUrl: imageUrl ?? '',
      placeholder: (context, url) {
        return const SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        );
      },
      errorWidget: (context, url, error) => const Icon(Icons.error),
    ),
  );
}
