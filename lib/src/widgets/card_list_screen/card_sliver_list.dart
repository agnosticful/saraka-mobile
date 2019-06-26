import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../blocs/authentication_bloc.dart';
import '../../blocs/card_detail_bloc.dart';
import '../../blocs/card_list_bloc.dart';
import '../../blocs/synthesizer_bloc.dart';
import '../../entities/card.dart';
import '../card_list_view_item.dart';

class CardSliverList extends StatefulWidget {
  @override
  _CardSliverListState createState() => _CardSliverListState();
}

class _CardSliverListState extends State<CardSliverList> {
  @override
  Widget build(BuildContext context) {
    return Consumer4<AuthenticationBloc, CardListBloc, CardDetailBlocFactory,
        SynthesizerBlocFactory>(
      builder: (
        context,
        authenticationBloc,
        cardListBloc,
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
                                  Provider<CardDetailBloc>(
                                    builder: (_) =>
                                        cardDetailBlocFactory.create(
                                          card: card,
                                          session: authenticationBloc.session,
                                        ),
                                  ),
                                  Provider<SynthesizerBloc>(
                                    builder: (_) =>
                                        synthesizerBlocFactory.create(),
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
                  )
                : SliverFillRemaining(),
          ),
    );
  }
}
