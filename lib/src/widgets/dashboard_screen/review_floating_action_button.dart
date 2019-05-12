import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:saraka/constants.dart';

class ReviewFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FloatingActionButton.extended(
        backgroundColor: SarakaColors.lightRed,
        foregroundColor: SarakaColors.white,
        icon: Icon(Feather.getIconData('check-circle')),
        label: Text(
          'Review Phrases',
          style: SarakaTextStyles.buttonLabel.copyWith(letterSpacing: 0),
        ),
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(24)),
        onPressed: () => Navigator.of(context).pushNamed('/review'),
      );
}
