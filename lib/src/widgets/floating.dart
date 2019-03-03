import 'package:flutter/widgets.dart';

class Floating extends StatelessWidget {
  Floating({Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x40000000),
              offset: Offset(0, 16),
              blurRadius: 12.0,
              spreadRadius: -16,
            ),
          ],
        ),
        child: child,
      );
}
