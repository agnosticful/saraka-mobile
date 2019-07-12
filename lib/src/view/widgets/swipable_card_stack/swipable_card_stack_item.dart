import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import './swipable_card_stack_controller.dart';
import './swipe_out_direction.dart';

@immutable
class SwipableCardStackItem extends StatefulWidget {
  SwipableCardStackItem({
    Key key,
    @required this.controller,
    this.constraints = const BoxConstraints.tightFor(),
    @required this.index,
    @required this.visibleCardLength,
    @required this.onSwipeOut,
    @required this.onSwipingRateChange,
    @required this.builder,
  })  : assert(constraints != null),
        assert(onSwipeOut != null),
        assert(onSwipingRateChange != null),
        assert(builder != null),
        super(key: key);

  final SwipableCardStackController controller;

  final BoxConstraints constraints;

  final int index;

  final int visibleCardLength;

  final void Function(SwipeOutDirection direction) onSwipeOut;

  final void Function(double swipingRate) onSwipingRateChange;

  final Widget Function(BuildContext, double swipingRate) builder;

  @override
  State<SwipableCardStackItem> createState() => _SwipableCardStackItemState();
}

class _SwipableCardStackItemState extends State<SwipableCardStackItem>
    with TickerProviderStateMixin {
  int _position;
  double _headSwipingRate;

  Function controllerListener;

  Offset _baseOffset;
  BoxConstraints _constraints;

  Offset _panOffset = _initialOffset;
  Offset _dragStartOffset;
  Offset _dragPosition;

  Offset _slideBackStartOffset;
  AnimationController _slideBackAnimationController;
  Tween<Offset> _slideOutTween;
  AnimationController _slideOutAnimationController;

  @override
  void initState() {
    super.initState();

    controllerListener = () {
      final previousPosition = _position;
      final position = widget.index - widget.controller.position;
      final headSwipingRate = widget.controller.headSwipingRate;

      if (previousPosition <= -1 && position >= 0) {
        setState(() {
          _position = position;
        });

        _slideOutAnimationController.reverse();
      } else {
        setState(() {
          _position = position;
          _headSwipingRate = headSwipingRate;
          _baseOffset = _calculateOffset();
          _constraints = _calculateConstraints();
        });
      }
    };

    _position = widget.index - widget.controller.position;
    _headSwipingRate = widget.controller.headSwipingRate;
    _baseOffset = _calculateOffset();
    _constraints = _calculateConstraints();

    widget.controller.addListener(controllerListener);

    _slideBackAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )
      ..addListener(() {
        final panOffset = Offset.lerp(
          _slideBackStartOffset,
          _initialOffset,
          Curves.easeInOut.transform(_slideBackAnimationController.value),
        );

        setState(() {
          _panOffset = panOffset;
        });

        widget.controller.headSwipingRate = _calculateSwipingRate();
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _panOffset = _initialOffset;
            _dragStartOffset = null;
            _slideBackStartOffset = null;
            _dragPosition = null;
          });

          widget.controller.headSwipingRate = _calculateSwipingRate();
        }
      });

    _slideOutAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: _position < 0 ? 1 : 0,
    )
      ..addListener(() {
        final panOffset = _slideOutTween.evaluate(_slideOutAnimationController);

        setState(() {
          _panOffset = panOffset;
        });

        widget.controller.headSwipingRate = _calculateSwipingRate();
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (_panOffset.dx < 0) {
            widget.onSwipeOut(SwipeOutDirection.left);
          } else {
            widget.onSwipeOut(SwipeOutDirection.right);
          }

          _slideOutTween = Tween(
            begin: _initialOffset,
            end: _slideOutTween.end,
          );
        }
      });
  }

  @override
  void dispose() {
    widget.controller.removeListener(controllerListener);
    _slideBackAnimationController.dispose();
    _slideOutAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = _position == 0
        ? GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanStart: _onPanStart,
            onPanEnd: _onPanEnd,
            onPanUpdate: _onPanUpdate,
            child: widget.builder(context, _calculateSwipingRate()),
          )
        : widget.builder(context, _calculateSwipingRate());
    final rect = _offset & _constraints.biggest;

    return Positioned.fromRect(
      rect: rect,
      child: Transform(
        transform: Matrix4.rotationZ(_getRotation(rect)),
        origin: _getRotationOrigin(rect),
        child: child,
      ),
    );
  }

  double _getRotation(Rect dragBounds) => _dragStartOffset == null
      ? 0
      : math.pi / 8 * 1 * _panOffset.dx / dragBounds.width;

  Offset _getRotationOrigin(Rect dragBounds) => _dragStartOffset == null
      ? _baseOffset
      : _dragStartOffset - dragBounds.topLeft;

  void _onPanStart(DragStartDetails details) {
    _dragStartOffset = details.globalPosition;

    if (_slideBackAnimationController.isAnimating) {
      _slideBackAnimationController.stop(canceled: true);
    }
  }

  void _onPanEnd(DragEndDetails details) {
    final isInLeft = _panOffset.dx / _constraints.maxWidth < -0.333;
    final isInRight = _panOffset.dx / _constraints.maxWidth > 0.333;

    setState(() {
      if (isInLeft || isInRight) {
        _slideOutTween = Tween(
          begin: _panOffset,
          end: Offset(
            isInLeft ? -_constraints.maxWidth * 2 : _constraints.maxWidth * 2,
            -_constraints.maxHeight / 5,
          ),
        );

        _slideOutAnimationController.forward(from: 0);
      } else {
        _slideBackStartOffset = _panOffset;
        _slideBackAnimationController.forward(from: 0);
      }
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragPosition = details.globalPosition;
      _panOffset = _dragPosition - _dragStartOffset;
    });

    widget.controller.headSwipingRate = _calculateSwipingRate();
  }

  Offset _calculateOffset() {
    final floatingPosition = _position - _headSwipingRate.abs();

    return Offset(
      8 * floatingPosition,
      4 * (widget.visibleCardLength - floatingPosition - 1) +
          4 * math.max(floatingPosition - widget.visibleCardLength + 1, 0),
    );
  }

  BoxConstraints _calculateConstraints() {
    final floatingPosition = _position - _headSwipingRate.abs();
    final constraints = widget.constraints;

    return constraints.copyWith(
      maxWidth: constraints.maxWidth - 16 * floatingPosition,
      maxHeight: constraints.maxHeight -
          4 * widget.visibleCardLength -
          16 * floatingPosition,
    );
  }

  double _calculateSwipingRate() {
    if (_panOffset.dx < 0) {
      return math.max(_panOffset.dx / _constraints.maxWidth / 0.333, -1);
    } else {
      return math.min(_panOffset.dx / _constraints.maxWidth / 0.333, 1);
    }
  }

  Offset get _offset => _baseOffset + _panOffset;

  static const _initialOffset = Offset.zero;
}
