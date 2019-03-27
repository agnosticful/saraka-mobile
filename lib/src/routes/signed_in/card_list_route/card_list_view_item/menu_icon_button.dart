import 'package:flutter/material.dart' show IconButton;
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';
import '../../card_delete_confirm_dialog/show_card_delete_confirm_dialog.dart';

class MenuIconButton extends StatelessWidget {
  MenuIconButton({Key key, @required Card card})
      : assert(card != null),
        _card = card,
        super(key: key);

  final Card _card;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Feather.getIconData('more-vertical'),
        color: SarakaColors.darkGray,
      ),
      onPressed: () {
        showCardDeleteConfirmDialog(context, card: _card);
      },
    );
  }
}
