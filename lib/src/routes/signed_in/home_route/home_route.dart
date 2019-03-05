import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saraka/domains.dart';
import 'package:saraka/usecases.dart';
import './home_screen.dart';

class HomeRoute extends MaterialPageRoute {
  HomeRoute({RouteSettings settings})
      : super(builder: _builder, settings: settings);

  static Widget _builder(BuildContext context) => Provider<CardList>(
        value: Provider.of<CardListUsecase>(context)(
            Provider.of<Authentication>(context).user)
          ..initialize(),
        child: HomeScreen(),
      );
}
