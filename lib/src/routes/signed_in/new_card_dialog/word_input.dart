import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';
import './synthesize_button.dart';

class WordInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WordInputState();
}

class _WordInputState extends State<WordInput> {
  final TextEditingController _controller = TextEditingController();

  VoidCallback _listener;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final cardAdderBloc = Provider.of<CardAdderBloc>(context);

      _listener = () {
        cardAdderBloc.setText(_controller.value.text);
      };

      _controller.addListener(_listener);
    });
  }

  @override
  void dispose() {
    super.dispose();

    _controller.removeListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      shape: SuperellipseShape(borderRadius: BorderRadius.circular(24)),
      color: SarakaColors.darkWhite,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'e.g. get used to',
          hintStyle: TextStyle(
            fontSize: 16,
            fontFamily: SarakaFonts.rubik,
            color: SarakaColors.darkGray,
          ),
          contentPadding: EdgeInsets.only(
            top: 14,
            bottom: 14,
            left: 16,
          ),
          border: InputBorder.none,
          suffixIcon: SynthesizeButton(),
        ),
        style: TextStyle(
          fontSize: 16.0,
          fontFamily: SarakaFonts.rubik,
          color: SarakaColors.darkBlack,
        ),
        autofocus: true,
      ),
    );
  }
}
