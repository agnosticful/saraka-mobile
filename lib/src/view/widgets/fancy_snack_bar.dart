import 'package:flutter/material.dart';
import 'package:saraka/constants.dart';

class FancySnackBar extends SnackBar {
  FancySnackBar({
    Key key,
    @required content,
    Color backgroundColor = SarakaColor.darkBlack,
    double elevation,
    ShapeBorder shape = const ContinuousRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(24)),
    ),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    SnackBarAction action,
    Duration duration = const Duration(milliseconds: 3000),
    Animation<double> animation,
  }) : super(
          key: key,
          content: DefaultTextStyle(
            style: TextStyle(fontFamily: SarakaFontFamily.rubik),
            child: content,
          ),
          backgroundColor: backgroundColor,
          elevation: elevation,
          shape: shape,
          behavior: behavior,
          action: action,
          duration: duration,
          animation: animation,
        );
}
