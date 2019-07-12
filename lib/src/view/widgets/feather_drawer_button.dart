import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class FeatherDrawerButton extends StatelessWidget {
  final Widget child;

  FeatherDrawerButton({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Feather.getIconData('menu')),
      onPressed: () => Scaffold.of(context).openDrawer(),
      tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
    );
  }
}
