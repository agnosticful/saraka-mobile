import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/widgets.dart';

class CardSliverList extends StatefulWidget {
  @override
  _CardSliverListState createState() => _CardSliverListState();
}

class _CardSliverListState extends State<CardSliverList> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<CardListBloc, CardDetailBlocFactory,
        SynthesizerBlocFactory>(
      builder: (context, cardListBloc, cardDetailBlocFactory,
              synthesizerBlocFactory) =>
          StreamBuilder<List<Card>>(
            stream: cardListBloc.cards,
            initialData: cardListBloc.cards.value,
            builder: (context, snapshot) => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final card = snapshot.requireData[i ~/ 2];

                      return i.isEven
                          ? MultiProvider(
                              key: ValueKey(card.id),
                              providers: [
                                Provider<CardDetailBloc>(
                                  value: cardDetailBlocFactory.create(card),
                                ),
                                Provider<SynthesizerBloc>(
                                  value: synthesizerBlocFactory.create(),
                                ),
                              ],
                              child: CardListViewItem(
                                card: card,
                              ),
                            )
                          : SizedBox(height: 16);
                    },
                    childCount:
                        math.max(0, snapshot.requireData.length * 2 - 1),
                  ),
                ),
          ),
    );
  }
}
