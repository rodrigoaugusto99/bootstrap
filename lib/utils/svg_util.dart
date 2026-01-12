import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum SvgEnum {
  svg('svg'),
  ;

  final String slug;
  const SvgEnum(this.slug);

  String get assetPath => 'assets/icons/$slug.svg';
}

class SvgUtil extends StatelessWidget {
  const SvgUtil(
    this.data, {
    super.key,
    this.color,
    this.size,
    this.height,
    this.width,
    this.onTap,
  });

  final Color? color;
  final double? size;
  final double? height;
  final double? width;
  final SvgEnum data;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: SvgPicture.asset(
        color: color,
        data.assetPath,
        height: height ?? size,
        width: width ?? size,
        // fit: BoxFit.cover,
      ),
    );
  }
}
