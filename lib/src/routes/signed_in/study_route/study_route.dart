import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import './study_screen.dart';

class StudyRoute extends MaterialPageRoute {
  StudyRoute({RouteSettings settings})
      : super(builder: _builder, settings: settings);

  static Widget _builder(BuildContext context) => MultiProvider(
        providers: [
          StatefulProvider<CardLearningBloc>(
            valueBuilder: (_) =>
                Provider.of<CardLearningBlocFactory>(context).create(),
          ),
          StatefulProvider<SynthesizerBloc>(
            valueBuilder: (_) =>
                Provider.of<SynthesizerBlocFactory>(context).create(),
          ),
        ],
        child: StudyScreen(),
      );
}
