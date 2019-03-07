import 'package:flutter/material.dart';
import './card_list_screen.dart';

class CardListRoute extends MaterialPageRoute {
  CardListRoute({RouteSettings settings})
      : super(builder: _builder, settings: settings);

  static Widget _builder(BuildContext context) => CardListScreen();
}
