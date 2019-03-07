import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show LinearProgressIndicator;
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/domains.dart';
import 'package:saraka/usecases.dart';

class ProgressIndicator extends StatefulWidget {
  State<ProgressIndicator> createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator> {
  Stream<Iterable<Card>> _cardsInQueue;

  int _originalLength;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final authentication = Provider.of<Authentication>(context);
      final cardListUsecase = Provider.of<CardListUsecase>(context);
      final cardList = await cardListUsecase(authentication.user);
      final cardsInQueueInitially = await cardList.cardsInQueue.first;

      setState(() {
        _cardsInQueue = cardList.cardsInQueue;
        _originalLength = cardsInQueueInitially.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 2,
        child: _cardsInQueue == null || _originalLength == null
            ? LinearProgressIndicator(
                value: 0,
                backgroundColor: SarakaColors.darkGray,
                valueColor: AlwaysStoppedAnimation(SarakaColors.lightRed),
              )
            : StreamBuilder<Iterable<Card>>(
                stream: _cardsInQueue,
                initialData: [],
                builder: (context, snapshot) => LinearProgressIndicator(
                      value: (_originalLength - snapshot.requireData.length) /
                          _originalLength,
                      backgroundColor: SarakaColors.darkGray,
                      valueColor: AlwaysStoppedAnimation(SarakaColors.lightRed),
                    ),
              ),
      );
}
