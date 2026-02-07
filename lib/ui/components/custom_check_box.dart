import 'package:bootstrap/ui/common/app_colors.dart';
import 'package:bootstrap/utils/helpers.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function() onTap;
  const CustomCheckBox({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (_) {},
            activeColor: kcPrimaryColor,
          ),
          widthSeparator(4),
          styledText(
            text: text,
            fontSize: 16,
            fontWeightEnum:
                isSelected ? FontWeightEnum.semiBold : FontWeightEnum.regular,
          ),
        ],
      ),
    );
  }
}
