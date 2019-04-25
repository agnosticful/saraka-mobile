import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';

class DotIndicator extends StatelessWidget {
  DotIndicator({Key key, @required this.length, this.activeIndex = 0})
      : assert(length != null),
        assert(length >= 1),
        assert(activeIndex != null),
        assert(activeIndex >= 0),
        super(key: key);

  final int length;

  final int activeIndex;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          length * 2 - 1,
          (i) => i % 2 == 0
              ? _DotIndicatorItem(isActive: i ~/ 2 == activeIndex)
              : SizedBox(width: 16),
        ),
      );
}

class _DotIndicatorItem extends StatefulWidget {
  _DotIndicatorItem({Key key, @required this.isActive})
      : assert(isActive != null),
        super(key: key);

  final bool isActive;

  @override
  State<_DotIndicatorItem> createState() => _DotIndicatorItemState();
}

class _DotIndicatorItemState extends State<_DotIndicatorItem>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  Animation _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: widget.isActive ? 1 : 0,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCirc,
    );
  }

  @override
  void didUpdateWidget(_DotIndicatorItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) => Container(
            width: 6,
            height: 6,
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                color: ColorTween(
                  begin: SarakaColors.lightGray,
                  end: SarakaColors.darkGray,
                ).animate(_animation).value),
          ),
    );
  }
}
