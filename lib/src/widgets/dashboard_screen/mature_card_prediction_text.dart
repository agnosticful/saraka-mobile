import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';

class MatureCardPredictionText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CardListBloc>(
      builder: (context, cardListBloc) => StreamBuilder<List<Card>>(
            stream: cardListBloc.cards,
            initialData: cardListBloc.cards.value,
            builder: (context, snapshot) => Text(
                  snapshot.hasData
                      ? '${_extractAlmostMatureCards(snapshot.requireData).length} cards are going to be mature'
                      : 'Loading...',
                  overflow: TextOverflow.ellipsis,
                  style: SarakaTextStyles.body,
                  textAlign: TextAlign.center,
                ),
          ),
    );
  }

  List _extractAlmostMatureCards(List<Card> cards) => cards
      .where((card) =>
          DateTime.now()
              .add(const Duration(days: 7))
              .isAfter(card.nextReviewScheduledAt) &&
          card.nextReviewInterval * card.modifier >= const Duration(days: 365))
      .toList();
}
