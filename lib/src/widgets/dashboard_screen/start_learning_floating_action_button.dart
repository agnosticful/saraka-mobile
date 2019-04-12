import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:saraka/constants.dart';

class StartLearningFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FloatingActionButton.extended(
        heroTag: null,
        backgroundColor: SarakaColors.lightBlue,
        icon: Icon(Feather.getIconData('play')),
        label: Text(
          'Start learning',
          style: SarakaTextStyles.buttonLabel,
        ),
        shape: SuperellipseShape(borderRadius: BorderRadius.circular(24)),
        onPressed: () => Navigator.of(context).pushNamed('/study'),
      );
}
