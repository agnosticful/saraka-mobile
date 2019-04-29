import 'package:flutter/material.dart' hide Card;
import 'package:saraka/constants.dart';
import 'package:saraka/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';

// TODO has to change Consumer due to use CardListBloc
class ArticleListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          child: Stack(
            children: <Widget>[
              WaveBackground(color: SarakaColors.white),
              Consumer3<CardListBloc, CardDetailBlocFactory,
                  SynthesizerBlocFactory>(
                builder: (context, cardListBloc, cardDetailBlocFactory,
                        synthesizerBlocFactory) =>
                    StreamBuilder<List<Card>>(
                      stream: cardListBloc.cards,
                      initialData: cardListBloc.cards.value,
                      builder: (context, snapshot) =>
                          snapshot.hasData ? Container() : Container(),
                    ),
              ),
            ],
          ),
        ),
      );
}
