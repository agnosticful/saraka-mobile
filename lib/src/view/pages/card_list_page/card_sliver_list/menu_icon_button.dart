import 'package:flutter/material.dart' hide Card;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import '../../../../blocs/card_delete_bloc.dart';
import '../../../routes/card_confirm_deletion_route.dart';
import '../../../widgets/fancy_snack_bar.dart';

class MenuIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Feather.getIconData('more-vertical'),
        color: SarakaColor.darkGray,
      ),
      onPressed: () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) async {
    final RenderBox self = context.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    final selectedItem = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          self.localToGlobal(
            Offset.zero,
            ancestor: overlay,
          ),
          self.localToGlobal(
            self.size.bottomRight(Offset.zero),
            ancestor: overlay,
          ),
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
      _onDeleteSelected(context);
    }
  }

  _onDeleteSelected(BuildContext context) async {
    final cardDeleteBloc = Provider.of<CardDeleteBloc>(context);
    final card = cardDeleteBloc.card;

    final result = await Navigator.of(context).pushNamed(
      "/cards:confirmDeletion",
      arguments: CardConfirmDeletionRouteArguments(card: card),
    );

    if (result) {
      final scaffold = Scaffold.of(context);

      scaffold.showSnackBar(
        FancySnackBar(content: Text("Deleting \"${card.text}\"...")),
      );

      await cardDeleteBloc.delete();

      scaffold.showSnackBar(
        FancySnackBar(content: Text("\"${card.text}\" has been deleted!")),
      );
    }
  }
}
