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
      final cardCreateBloc = Provider.of<CardCreateBloc>(context);

      _listener = () {
        cardCreateBloc.setText(_controller.value.text);
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
    return Consumer<CardCreateBloc>(
      builder: (context, cardCreateBloc, _) => StreamBuilder<CardAddingState>(
            stream: cardCreateBloc.state,
            initialData: cardCreateBloc.state.value,
            builder: (context, snapshot) => TextField(
                  controller: _controller,
                  cursorColor: SarakaColor.lightRed,
                  autofocus: true,
                  enabled: snapshot.requireData == CardAddingState.initial,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(16),
                    hintText: "e.g. get used to",
                    hintStyle: SarakaTextStyle.heading.apply(
                      color: SarakaColor.lightGray,
                    ),
                    border: InputBorder.none,
                  ),
                  style: SarakaTextStyle.heading,
                ),
          ),
    );
  }
}
