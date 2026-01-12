import 'package:bootstrap/utils/helpers.dart';
import 'package:flutter/material.dart';

/*
GestureDetector(
              child: const SvgUtil(SvgEnum.matrizInfo),
              onTapDown: (details) {
                showPopup(
                  context,
                  details.globalPosition,
                );
              },
            ),
 */

void showLogoutPopup({
  required BuildContext context,
  required Offset offset,
  required VoidCallback onTap,
}) async {
  await showMenu(
    color: Colors.grey,
    context: context,
    position: RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + 30,
      offset.dx,
      offset.dy,
    ),
    items: [
      PopupMenuItem<int>(
        value: 0,
        child: Row(
          children: [
            widthSeparator(10),
            styledText(
              text: 'Sair da conta',
              isBold: true,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    ],
  ).then((value) {
    if (value != null) {
      onTap();
    }
  });
}
