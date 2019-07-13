import 'package:flutter/material.dart' show PopupMenuItem, showMenu;
import 'package:flutter/material.dart' show IconButton;
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/src/view/routes/card_confirm_deletion_route.dart';

class MenuIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Feather.getIconData('more-vertical'),
        color: SarakaColor.darkGray,
      ),
      onPressed: () => onPressed(context),
    );
  }

  void onPressed(BuildContext context) async {
    final RenderBox self = context.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    final selectedItem = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          self.localToGlobal(Offset.zero, ancestor: overlay),
          self.localToGlobal(self.size.bottomRight(Offset.zero),
              ancestor: overlay),
        ),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          value: "",
          child: Text(
            "Delete",
            style: SarakaTextStyle.body,
          ),
        ),
      ],
    );

    if (selectedItem != null) {
      final card = Provider.of<CardDetailBloc>(context).card;

      Navigator.of(context).pushNamed(
        "/cards:confirmDeletion",
        arguments: CardConfirmDeletionRouteArguments(card: card),
      );
    }
  }
}
