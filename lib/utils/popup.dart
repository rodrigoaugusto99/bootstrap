import 'package:bootstrap/utils/helpers.dart';
import 'package:flutter/material.dart';

/*
onTapDown: (details) {
              showOptionsPopup(
                offset: details.globalPosition,
                context: context,
                onTap: (option) {
                  viewModel.handleOnPopupOption(option);
                },
              );
            },


  viewmodel:

  final _authService = locator<AuthService>();

  void handleOnPopupOption(PopupOptions option) {
    if (option == PopupOptions.logout) {
      _authService.signOut();
    }
  }

 */

enum PopupOptions {
  logout('Sair da conta');

  const PopupOptions(this.label);
  final String label;
}

void showOptionsPopup({
  required BuildContext context,
  required Offset offset,
  required Function(PopupOptions) onTap,
  List<PopupOptions>? options,
}) async {
  final items = options ?? PopupOptions.values;
  await showMenu(
    color: Colors.grey,
    context: context,
    position: RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + 30,
      offset.dx,
      offset.dy,
    ),
    items: items.map((PopupOptions option) {
      return PopupMenuItem<PopupOptions>(
        value: option,
        child: Row(
          children: [
            widthSeparator(10),
            styledText(
              text: option.label,
              isBold: true,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      );
    }).toList(),
  ).then((value) {
    if (value != null) {
      onTap(value);
    }
  });
}

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
