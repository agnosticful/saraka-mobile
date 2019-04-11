import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import './draggable_card.dart';

class CardBundle extends StatefulWidget {
  State<CardBundle> createState() => _CardBundleState();
}

class _CardBundleState extends State<CardBundle> {
  CardReviewBloc _cardReviewBloc;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final cardReviewBloc = Provider.of<CardReviewBloc>(context);

      setState(() {
        _cardReviewBloc = cardReviewBloc;
      });
    });
  }

  @override
  Widget build(BuildContext context) => _cardReviewBloc == null
      ? Container()
      : StreamBuilder<List<Card>>(
          stream: _cardReviewBloc.cardsInQueue,
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.requireData.length == 0) {
              return Container();
            }

            final children = <Widget>[];
            final firstFiveCards =
                snapshot.requireData.take(5).toList().reversed.toList();

            for (int i = 0; i < firstFiveCards.length; ++i) {
              children.add(DraggableCard(
                key: Key(firstFiveCards[i].id),
                card: firstFiveCards[i],
                cardsInFront: firstFiveCards.length - i - 1,
              ));
            }

            return Stack(children: children);
          });
}
