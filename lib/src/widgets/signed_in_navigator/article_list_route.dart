import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../blocs/article_list_bloc.dart';

class ArticleListRoute extends CupertinoPageRoute {
  ArticleListRoute({@required Widget child, RouteSettings settings})
      : super(
          builder: (BuildContext context) => StatefulProvider(
                valueBuilder: (_) =>
                    Provider.of<ArticleListBlocFactory>(context).create(),
                child: child,
              ),
          settings: settings,
        );
}
