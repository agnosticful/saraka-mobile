import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';

class WordInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WordInputState();
}

class _WordInputState extends State<WordInput> {
  final _textFieldController = TextEditingController();

  VoidCallback _textFieldListener;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final newCardEditBloc = Provider.of<NewCardEditBloc>(context);

      _textFieldListener = () {
        newCardEditBloc.setText(_textFieldController.value.text);
      };

      _textFieldController.addListener(_textFieldListener);
    });
  }

  @override
  void dispose() {
    _textFieldController.removeListener(_textFieldListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
        controller: _textFieldController,
        cursorColor: SarakaColor.lightRed,
        autofocus: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16),
          hintText: "e.g. get used to",
          hintStyle: SarakaTextStyle.heading.apply(
            color: SarakaColor.lightGray,
          ),
          border: InputBorder.none,
        ),
        style: SarakaTextStyle.heading,
      );
}
