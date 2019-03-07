import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:saraka/constants.dart';
import '../new_card_dialog/show_new_card_dialog.dart';

class NewCardFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FloatingActionButton.extended(
        backgroundColor: SarakaColors.lightRed,
        icon: Icon(Feather.getIconData('plus')),
        label: Text(
          'New Card',
          style: TextStyle(
            fontFamily: SarakaFonts.rubik,
            fontSize: 16,
          ),
        ),
        shape: SuperellipseShape(borderRadius: BorderRadius.circular(24)),
        onPressed: () => _onPressed(context),
      );

  void _onPressed(BuildContext context) => showNewCardDialog(context);
}
