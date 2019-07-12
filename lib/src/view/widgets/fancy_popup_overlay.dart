import 'package:flutter/widgets.dart';

class FancyPopupOverlay extends AnimatedWidget {
  FancyPopupOverlay({
    Key key,
    @required this.scaleAnimation,
    @required this.child,
  }) : super(
          key: key,
          listenable: scaleAnimation,
        );

  final Widget child;

  final Animation<double> scaleAnimation;

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: Container(
          child: Center(
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          ),
        ),
      );
}
