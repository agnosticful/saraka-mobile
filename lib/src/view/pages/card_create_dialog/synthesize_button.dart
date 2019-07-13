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
  StreamSubscription _subscription;

  String _text;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final cardCreateBloc = Provider.of<CardCreateBloc>(context);
      final synthesizerBloc = Provider.of<SynthesizerBloc>(context);

      _subscription = cardCreateBloc.text
          .debounceTime(const Duration(milliseconds: 500))
          .listen((text) {
        if (text.isValid) {
          synthesizerBloc.cacheInAdvance(text.text);
        }
      });

      cardCreateBloc.text.listen((text) {
        setState(() {
          _text = text.isValid ? text.text : null;
        });
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer<SynthesizerBloc>(
        builder: (context, synthesizerBloc, _) => StreamBuilder<bool>(
              stream: synthesizerBloc.isCaching,
              initialData: false,
              builder: (context, snapshot) {
                if (_text == null) {
                  return IconButton(
                    icon: Icon(Feather.getIconData('volume-2')),
                    color: SarakaColor.lightGray,
                    onPressed: null,
                  );
                }

                if (snapshot.requireData) {
                  return SizedBox.fromSize(
                    size: Size.square(48),
                    child: Center(
                      child: SizedBox.fromSize(
                        size: Size.square(20),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              SarakaColor.lightRed),
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  );
                }

                return IconButton(
                  icon: Icon(Feather.getIconData('volume-2')),
                  color: SarakaColor.lightRed,
                  onPressed: () => _onSoundPressed(context),
                );
              },
            ),
      );

  void _onSoundPressed(BuildContext context) {
    final synthesizerBloc = Provider.of<SynthesizerBloc>(context);

    synthesizerBloc.play(_text);
  }
}
