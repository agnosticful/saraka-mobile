import 'package:flutter/material.dart';
import './study_screen.dart';

class StudyRoute extends MaterialPageRoute {
  StudyRoute({RouteSettings settings})
      : super(builder: _builder, settings: settings);

  static Widget _builder(BuildContext context) => StudyScreen();
}
