import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';

class WordInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WordInputState();
}

class _WordInputState extends State<WordInput> {
  final _controller = TextEditingController();

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
    _controller.removeListener(_listener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CardAdderBloc>(
      builder: (context, cardAdderBloc) => StreamBuilder<CardAddingState>(
            stream: cardAdderBloc.state,
            initialData: cardAdderBloc.state.value,
            builder: (context, snapshot) => TextField(
                  controller: _controller,
                  cursorColor: SarakaColors.lightRed,
                  autofocus: true,
                  enabled: snapshot.requireData == CardAddingState.initial,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(16),
                    hintText: "e.g. get used to",
                    hintStyle: TextStyle(
                      color: SarakaColors.lightGray,
                      fontSize: 18,
                      fontFamily: SarakaFonts.rubik,
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                    ),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    color: SarakaColors.lightBlack,
                    fontSize: 18,
                    fontFamily: SarakaFonts.rubik,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
          ),
    );
  }
}
