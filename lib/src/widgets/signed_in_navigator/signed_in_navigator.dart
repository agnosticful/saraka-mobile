import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import './card_list_route.dart';
import './study_route.dart';

class SignedInNavigator extends StatelessWidget {
  SignedInNavigator({
    Key key,
    @required this.cardList,
    @required this.study,
  })  : assert(cardList != null),
        assert(study != null),
        super(key: key);

  final Widget cardList;

  final Widget study;

  @override
  Widget build(BuildContext context) => Navigator(
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case "/":
              return StudyRoute(
                settings: settings,
                child: study,
              );
            case "/cards":
              return CardListRoute(
                settings: settings,
                child: cardList,
              );
          }
        },
        initialRoute: "/",
      );
}
