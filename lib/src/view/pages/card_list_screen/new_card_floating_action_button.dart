import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:saraka/constants.dart';

class NewCardFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FloatingActionButton.extended(
        backgroundColor: SarakaColors.lightRed,
        foregroundColor: SarakaColors.white,
        icon: Icon(Feather.getIconData('plus')),
        label: Text(
          'New Card',
          style: SarakaTextStyles.buttonLabel,
        ),
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(24)),
        onPressed: () => _onPressed(context),
      );

  void _onPressed(BuildContext context) =>
      Navigator.of(context).pushNamed("/cards:new");
}
