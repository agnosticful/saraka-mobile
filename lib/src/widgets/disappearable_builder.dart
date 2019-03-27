import 'package:flutter/widgets.dart';

class DisappearableBuilder extends StatefulWidget {
  DisappearableBuilder({
    Key key,
    this.isDisappeared = false,
    this.curve = Curves.easeInOut,
    @required this.child,
  })  : assert(isDisappeared != null),
        assert(curve != null),
        assert(child != null),
        super(key: key);

  final bool isDisappeared;

  final Curve curve;

  final Widget child;

  @override
  State<DisappearableBuilder> createState() => _DisappearableBuilderState();
}

class _DisappearableBuilderState extends State<DisappearableBuilder>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  Animation _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: widget.isDisappeared ? 0 : 1,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: widget.curve,
    );
  }

  @override
  void didUpdateWidget(DisappearableBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isDisappeared != oldWidget.isDisappeared) {
      if (widget.isDisappeared) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: ScaleTransition(
        scale: _animation,
        child: widget.child,
      ),
    );
  }
}
