import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show IconButton;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:saraka/constants.dart';

class BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => IconButton(
        icon: Icon(Feather.getIconData('corner-up-left')),
        color: SarakaColors.white,
        disabledColor: SarakaColors.darkGray,
        onPressed: null,
      );
}
