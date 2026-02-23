import 'package:bootstrap/ui/common/app_colors.dart';
import 'package:bootstrap/utils/app_cached_network_image.dart';
import 'package:bootstrap/utils/helpers.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.imageUrl,
    this.onProfileTap,
    this.widget,
  });

  final String title;
  final String? imageUrl;
  final Function()? onProfileTap;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return decContainer(
      color: kcPrimaryColor,
      // bottomLeftRadius: 16,
      // bottomRightRadius: 16,
      leftPadding: 24,
      rightPadding: 24,
      topPadding: 12,
      bottomPadding: 12,
      //height: 64,
      child: SafeArea(
        child: Row(
          // clipBehavior: Clip.none,
          children: [
            styledText(
              text: title,
              fontSize: 22,
              fontWeightEnum: FontWeightEnum.semiBold,
            ),
            const Spacer(),
            if (imageUrl != null)
              appCachedNetWorkImage(
                imageUrl: imageUrl,
                isCircle: true,
                radius: 100,
                onTap: onProfileTap,
                height: 40,
                width: 40,
              ),
            if (widget != null) widget!,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(84);
}
