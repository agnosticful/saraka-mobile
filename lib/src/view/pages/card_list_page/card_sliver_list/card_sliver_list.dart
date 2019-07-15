import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/entities.dart';
import './card_sliver_list_item.dart';

class CardSliverList extends StatefulWidget {
  @override
  _CardSliverListState createState() => _CardSliverListState();
}

class _CardSliverListState extends State<CardSliverList> {
  @override
  Widget build(BuildContext context) {
    return Consumer5<AuthenticationBloc, CardListBloc, CardDeleteBlocFactory,
        CardDetailBlocFactory, SynthesizerBlocFactory>(
      builder: (
        context,
        authenticationBloc,
        cardListBloc,
        cardDeleteBlocFactory,
        cardDetailBlocFactory,
        synthesizerBlocFactory,
        _,
      ) =>
          StreamBuilder<List<Card>>(
        stream: cardListBloc.cards,
        initialData: cardListBloc.cards.value,
        builder: (context, snapshot) => snapshot.hasData
            ? SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final card = snapshot.requireData[i ~/ 2];

                    return i.isEven
                        ? MultiProvider(
                            key: ValueKey(card.id),
                            providers: [
                              Provider<CardDeleteBloc>(
                                builder: (_) => cardDeleteBlocFactory.create(
                                  card: card,
                                  session: authenticationBloc.session.value,
                                ),
                              ),
                              Provider<CardDetailBloc>(
                                builder: (_) => cardDetailBlocFactory.create(
                                  card: card,
                                  session: authenticationBloc.session.value,
                                ),
                              ),
                              Provider<SynthesizerBloc>(
                                builder: (_) => synthesizerBlocFactory.create(),
                              ),
                            ],
                            child: CardSliverListItem(
                              card: card,
                            ),
                          )
                        : SizedBox(height: 16);
                  },
                  childCount: math.max(0, snapshot.requireData.length * 2 - 1),
                ),
              )
            : SliverFillRemaining(),
      ),
    );
  }
}
