import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import '../../blocs/card_list_bloc.dart';

class ReadyCardLengthText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CardListBloc>(
      builder: (context, cardListBloc) => StreamBuilder<List<Card>>(
            stream: cardListBloc.cards,
            initialData: cardListBloc.cards.value,
            builder: (context, snapshot) => Text(
                  snapshot.hasData
                      ? '${snapshot.requireData.where((iter) => iter.nextReviewScheduledAt.isBefore(DateTime.now())).length} cards you will study today'
                      : 'Loading...',
                  overflow: TextOverflow.ellipsis,
                  style: SarakaTextStyles.body,
                  textAlign: TextAlign.center,
                ),
          ),
    );
  }
}
