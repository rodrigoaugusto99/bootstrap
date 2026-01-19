import 'package:flutter/material.dart';

enum ImageEnum {
  logo('logo'),
  jpg('jpg', ext: 'jpg'),
  ;

  final String slug;
  final String ext;
  const ImageEnum(this.slug, {this.ext = 'png'});

  String get assetPath => 'assets/images/$slug.$ext';

  String get assetName => 'assets/images/$slug.$ext';

  ImageProvider get provider => AssetImage(assetPath);
}

class ImageUtil extends StatelessWidget {
  const ImageUtil(
    this.data, {
    super.key,
    this.color,
    this.height,
    this.scale,
    this.width,
    this.withoutCover = false,
  });

  final Color? color;
  final double? height;
  final double? width;
  final ImageEnum data;
  final double? scale;
  final bool withoutCover;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      color: color,
      data.assetPath,
      height: height,
      width: width,
      fit: withoutCover ? null : BoxFit.cover,
      scale: scale,
    );
  }
}
