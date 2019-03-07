import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/domains.dart';
import 'package:saraka/usecases.dart';
import './draggable_card.dart';

class CardBundle extends StatefulWidget {
  State<CardBundle> createState() => _CardBundleState();
}

class _CardBundleState extends State<CardBundle> {
  CardList _cardList;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final authentication = Provider.of<Authentication>(context);
      final cardListUsecase = Provider.of<CardListUsecase>(context);
      final cardList = await cardListUsecase(authentication.user);

      setState(() {
        _cardList = cardList;
      });
    });
  }

  @override
  Widget build(BuildContext context) => _cardList == null
      ? Container()
      : StreamBuilder<Iterable<Card>>(
          stream: _cardList.cardsInQueue,
          initialData: [],
          builder: (context, snapshot) {
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
