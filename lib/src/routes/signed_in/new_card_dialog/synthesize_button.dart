import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';

class SynthesizeButton extends StatefulWidget {
  State<SynthesizeButton> createState() => _SynthesizeButtonState();
}

class _SynthesizeButtonState extends State<SynthesizeButton> {
  SynthesizerBloc _synthesizerBloc;

  StreamSubscription _subscription;

  String _text;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final cardAdderBloc = Provider.of<CardAdderBloc>(context);
      final synthesizerBloc = Provider.of<SynthesizerBloc>(context);

      _subscription = cardAdderBloc.text
          .debounce(Duration(milliseconds: 500))
          .listen((text) {
        if (text.isValid) {
          synthesizerBloc.cacheInAdvance(text.text);
        }
      });

      cardAdderBloc.text.listen((text) {
        setState(() {
          _text = text.isValid ? text.text : null;
        });
      });

      setState(() {
        _synthesizerBloc = synthesizerBloc;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _synthesizerBloc != null
      ? StreamBuilder<bool>(
          stream: _synthesizerBloc.isCaching,
          initialData: false,
          builder: (context, snapshot) {
            if (_text == null) {
              return Container(width: 0, height: 0);
            }

            if (snapshot.requireData) {
              return Icon(
                Feather.getIconData('loader'),
                color: SarakaColors.lightGray,
              );
            }

            return IconButton(
              icon: Icon(Feather.getIconData('volume-2')),
              color: SarakaColors.darkCyan,
              onPressed: _onSoundPressed,
            );
          },
        )
      : Container();

  void _onSoundPressed() {
    _synthesizerBloc.play(_text);
  }
}
