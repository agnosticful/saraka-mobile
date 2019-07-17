import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../../../blocs/authentication_bloc.dart';
import '../../../../blocs/card_delete_bloc.dart';
import '../../../../blocs/card_detail_bloc.dart';
import '../../../../blocs/card_list_bloc.dart';
import '../../../../bloc_factories/card_delete_bloc_factory.dart';
import '../../../../bloc_factories/card_detail_bloc_factory.dart';
import './card_sliver_list_item.dart';

class CardSliverList extends StatefulWidget {
  @override
  _CardSliverListState createState() => _CardSliverListState();
}

class _CardSliverListState extends State<CardSliverList> {
  @override
  Widget build(BuildContext context) {
    return Consumer4<AuthenticationBloc, CardListBloc, CardDeleteBlocFactory,
        CardDetailBlocFactory>(
      builder: (
        context,
        authenticationBloc,
        cardListBloc,
        cardDeleteBlocFactory,
        cardDetailBlocFactory,
        _,
      ) =>
          StreamBuilder<AuthenticationSession>(
        stream: authenticationBloc.session,
        initialData: authenticationBloc.session.value,
        builder: (context, sessionSnapshot) => StreamBuilder<List<Card>>(
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
                                  key: ObjectKey(sessionSnapshot.requireData),
                                  builder: (_) => cardDeleteBlocFactory.create(
                                    card: card,
                                    session: sessionSnapshot.requireData,
                                  )..initialize(),
                                  dispose: (_, cardDeleteBloc) =>
                                      cardDeleteBloc.dispose(),
                                ),
                                Provider<CardDetailBloc>(
                                  key: ObjectKey(sessionSnapshot.requireData),
                                  builder: (_) => cardDetailBlocFactory.create(
                                    card: card,
                                    session: sessionSnapshot.requireData,
                                  ),
                                  dispose: (_, cardDetailBloc) =>
                                      cardDetailBloc.dispose(),
                                ),
                              ],
                              child: CardSliverListItem(
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
      ),
    );
  }
}
