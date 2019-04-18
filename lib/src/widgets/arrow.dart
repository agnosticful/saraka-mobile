import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';

class Arrow extends StatelessWidget {
  Arrow({
    Key key,
    this.color = SarakaColors.darkBlack,
    this.strokeWidth = 1.0,
    this.direction = ArrowDirection.leftToRight,
  }) : super(key: key);

  final Color color;

  final double strokeWidth;

  final ArrowDirection direction;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 16),
      child: CustomPaint(
        painter: _ArrowPainter(
          color: color,
          strokeWidth: strokeWidth,
          direction: direction,
        ),
      ),
    );
  }
}

enum ArrowDirection {
  leftToRight,
  rightToLeft,
}

class _ArrowPainter extends CustomPainter {
  _ArrowPainter({
    @required this.color,
    @required this.strokeWidth,
    @required this.direction,
  }) : super();

  final Color color;

  final double strokeWidth;

  final ArrowDirection direction;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    final path = Path()
      ..moveTo(0, size.height / 2)
      ..relativeLineTo(size.width, 0);

    if (direction == ArrowDirection.leftToRight) {
      path
        ..moveTo(size.width, size.height / 2)
        ..relativeLineTo(-size.height / 2, -size.height / 2)
        ..moveTo(size.width, size.height / 2)
        ..relativeLineTo(-size.height / 2, size.height / 2);
    } else {
      path
        ..moveTo(0, size.height / 2)
        ..relativeLineTo(size.height / 2, -size.height / 2)
        ..moveTo(0, size.height / 2)
        ..relativeLineTo(size.height / 2, size.height / 2);
    }

    path.close();

    paint.style = PaintingStyle.stroke;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ArrowPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}
