import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';

class StudyRoute extends CupertinoPageRoute {
  StudyRoute({@required Widget child, RouteSettings settings})
      : super(
          builder: (BuildContext context) => MultiProvider(
                providers: [
                  StatefulProvider<CardStudyBloc>(
                    valueBuilder: (_) =>
                        Provider.of<CardStudyBlocFactory>(context).create()
                          ..initialize(),
                  ),
                  StatefulProvider<SynthesizerBloc>(
                    valueBuilder: (_) =>
                        Provider.of<SynthesizerBlocFactory>(context).create(),
                  ),
                ],
                child: child,
              ),
          settings: settings,
        );
}
