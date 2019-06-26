import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../blocs/card_review_bloc.dart';
import '../../blocs/synthesizer_bloc.dart';
import '../swipable_card_stack.dart';
import './stacked_card.dart';

class CardStack extends StatefulWidget {
  CardStack({Key key, @required this.controller})
      : assert(controller != null),
        super(key: key);

  final SwipableCardStackController controller;

  @override
  State<CardStack> createState() => _CardStackState();
}

class _CardStackState extends State<CardStack> {
  Function _listener;

  int _previousPosition;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _previousPosition = widget.controller.position;

      final cardReviewBloc = Provider.of<CardReviewBloc>(context);
      final synthesizerBloc = Provider.of<SynthesizerBloc>(context);

      _listener = () {
        if (widget.controller.position != _previousPosition) {
          final card = cardReviewBloc.cards[widget.controller.position];

          synthesizerBloc.play(card.text);
        }

        _previousPosition = widget.controller.position;
      };

      widget.controller.addListener(_listener);

      synthesizerBloc.play(cardReviewBloc.cards[0].text);
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CardReviewBloc>(
      builder: (context, cardReviewBloc, _) => StreamBuilder(
          stream: cardReviewBloc.isInitialized,
          initialData: cardReviewBloc.isInitialized.value,
          builder: (context, snapshot) {
            return snapshot.requireData
                ? SwipableCardStack(
                    controller: widget.controller,
                    onSwipeOut: (index, direction) {
                      if (direction == SwipeOutDirection.right) {
                        cardReviewBloc
                            .reviewedWell(cardReviewBloc.cards[index]);
                      } else {
                        cardReviewBloc
                            .reviewedVaguely(cardReviewBloc.cards[index]);
                      }
                    },
                    itemBuilder: (context, i, swipingRate) => StackedCard(
                          card: cardReviewBloc.cards[i],
                          swipingRate: swipingRate,
                        ),
                    itemLength: cardReviewBloc.cards.length,
                    visibleItemLength: 3,
                  )
                : Container();
          }),
    );
  }
}
