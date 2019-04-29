import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';

class ArticleListRoute extends CupertinoPageRoute {
  ArticleListRoute({@required Widget normal, RouteSettings settings})
      : super(
          builder: (BuildContext context) => Consumer<AuthenticationBloc>(
                builder: (context, authenticationBloc) => StreamBuilder<User>(
                      stream: authenticationBloc.user,
                      initialData: authenticationBloc.user.value,
                      builder: (context, snapshot) => snapshot.hasData
                          ? StatefulProvider(
                              valueBuilder: (_) =>
                                  Provider.of<CardListBlocFactory>(context)
                                      .create(),
                              child: normal,
                            )
                          : Container(),
                    ),
              ),
          settings: settings,
        );
}
