import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../blocs/card_list_bloc.dart';

class CardListRoute extends CupertinoPageRoute {
  CardListRoute({@required Widget child, RouteSettings settings})
      : super(
          builder: (BuildContext context) => StatefulProvider(
                valueBuilder: (_) =>
                    Provider.of<CardListBlocFactory>(context).create(),
                child: child,
              ),
          settings: settings,
        );
}
