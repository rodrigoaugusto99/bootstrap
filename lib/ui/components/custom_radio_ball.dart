import 'package:flutter/material.dart';
import 'package:bootstrap/ui/common/app_colors.dart';
import 'package:bootstrap/utils/helpers.dart';

class CustomRadioBall extends StatelessWidget {
  const CustomRadioBall({
    super.key,
    this.onTap,
    required this.isSelected,
  });
  final Function()? onTap;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: decContainer(
        isCircle: true,
        allPadding: 4,
        width: 20,
        height: 20,
        borderWidth: 2,
        borderColor: isSelected ? kcPrimaryColor : const Color(0xff343330),
        color: Colors.white,
        child: isSelected
            ? decContainer(
                isCircle: true,
                color: kcPrimaryColor,
              )
            : null,
      ),
    );
  }
}
