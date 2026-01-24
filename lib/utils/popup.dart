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

void showStatePopup({
  required BuildContext context,
  required Offset offset,
  required Function(String) onSelected,
  required List<String> initialList,
}) async {
  await showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      offset.dx,
      offset.dy,
      offset.dx + 100,
      offset.dy + 100,
    ),
    items: initialList.map((String state) {
      return PopupMenuItem<String>(
        value: state,
        child: Text(state),
      );
    }).toList(),
  ).then((value) {
    if (value != null) {
      onSelected(value);
    }
  });
}

void showYearPopup({
  required BuildContext context,
  required Offset offset,
  required Function(int) onSelected,
  required List<int> years,
}) async {
  await showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + 30,
      offset.dx,
      offset.dy,
    ),
    items: years.map((int year) {
      return PopupMenuItem<int>(
        value: year,
        child: Text(year.toString()),
      );
    }).toList(),
  ).then((value) {
    if (value != null) {
      onSelected(value);
    }
  });
}

/*
void showDeliveryMethodPopup({
  required BuildContext context,
  required Offset offset,
  required Function(DeliveryMethod) onSelected,
  List<DeliveryMethod>? initialList,
}) async {
  final methods = initialList ?? DeliveryMethod.values;
  await showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      offset.dx,
      offset.dy,
      offset.dx + 100,
      offset.dy + 100,
    ),
    items: methods.map((DeliveryMethod deliveryMethod) {
      return PopupMenuItem<DeliveryMethod>(
        value: deliveryMethod,
        child: Text(translateEnum(deliveryMethod)),
      );
    }).toList(),
  ).then((value) {
    if (value != null) {
      onSelected(value);
    }
  });
}
*/
