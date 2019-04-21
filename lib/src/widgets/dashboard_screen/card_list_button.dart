import 'package:flutter/material.dart' hide Card;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';

class CardListButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CardListBloc>(
      builder: (context, cardListBloc) => StreamBuilder<List<Card>>(
            stream: cardListBloc.cards,
            initialData: cardListBloc.cards.value,
            builder: (context, snapshot) => FlatButton(
                  shape: SuperellipseShape(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: EdgeInsets.fromLTRB(24, 14, 16, 14),
                  onPressed: () => Navigator.of(context).pushNamed('/cards'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        snapshot.hasData
                            ? 'See All ${snapshot.requireData.length} Cards'
                            : "Loading...",
                        overflow: TextOverflow.ellipsis,
                        style: SarakaTextStyles.buttonLabel.copyWith(
                          color: SarakaColors.lightBlack,
                        ),
                      ),
                      Icon(
                        Feather.getIconData('chevron-right'),
                        color: SarakaColors.lightBlack,
                        size: 20,
                      ),
                    ],
                  ),
                ),
          ),
    );
  }
}
