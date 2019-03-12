import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import './card_list_screen.dart';

class CardListRoute extends MaterialPageRoute {
  CardListRoute({RouteSettings settings})
      : super(builder: _builder, settings: settings);

  static Widget _builder(BuildContext context) => StatefulProvider(
        valueBuilder: (_) => Provider.of<CardListBlocFactory>(context).create(),
        child: CardListScreen(),
      );
}
