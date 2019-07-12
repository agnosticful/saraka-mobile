import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import './swipable_card_stack_controller.dart';
import './swipable_card_stack_item.dart';
import './swipe_out_direction.dart';

export './swipable_card_stack_controller.dart';
export './swipe_out_direction.dart';

@immutable
class SwipableCardStack extends StatefulWidget {
  SwipableCardStack({
    Key key,
    SwipableCardStackController controller,
    @required this.itemBuilder,
    @required this.itemLength,
    this.visibleItemLength = 3,
    this.onSwipeOut,
  })  : assert(itemBuilder != null),
        assert(itemLength != null),
        assert(visibleItemLength != null),
        controller = controller ?? SwipableCardStackController(),
        super(key: key);

  final SwipableCardStackController controller;

  final Widget Function(BuildContext, int index, double swipingRate)
      itemBuilder;

  final int itemLength;

  final int visibleItemLength;

  final void Function(int index, SwipeOutDirection direction) onSwipeOut;

  @override
  State<SwipableCardStack> createState() => _SwipableCardStackState();
}

class _SwipableCardStackState extends State<SwipableCardStack> {
  SwipableCardStackController controller;

  @override
  void initState() {
    super.initState();

    controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final children = List.generate(
          math.min(controller.position + widget.visibleItemLength + 1,
              widget.itemLength),
          (index) {
            return SwipableCardStackItem(
              key: ValueKey(index),
              controller: controller,
              constraints: constraints,
              index: index,
              visibleCardLength: widget.visibleItemLength,
              onSwipeOut: (direction) {
                if (widget.onSwipeOut != null) {
                  widget.onSwipeOut(index, direction);
                }

                controller.next();
              },
              onSwipingRateChange: (swipingRate) {
                controller.headSwipingRate = swipingRate;
              },
              builder: (context, swipingRate) =>
                  widget.itemBuilder(context, index, swipingRate),
            );
          },
          growable: false,
        ).reversed.toList();

        return Stack(
          overflow: Overflow.visible,
          children: children,
        );
      },
    );
  }
}
