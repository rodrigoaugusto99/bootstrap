import 'package:bootstrap/utils/helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
    const SizedBox();
  }

  return decContainer(
    isCircle: isCircle,
    radius: radius,
    child: GestureDetector(
      onTap: onTap,
      child: CachedNetworkImage(
        height: height,
        width: width,
        fit: BoxFit.cover,
        imageUrl: imageUrl ?? '',
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
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    ),
  );
}
