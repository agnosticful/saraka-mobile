import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import '../../blocs/card_adder_bloc.dart';
import '../../blocs/synthesizer_bloc.dart';

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
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer<SynthesizerBloc>(
        builder: (context, synthesizerBloc) => StreamBuilder<bool>(
              stream: synthesizerBloc.isCaching,
              initialData: false,
              builder: (context, snapshot) {
                if (_text == null) {
                  return IconButton(
                    icon: Icon(Feather.getIconData('volume-2')),
                    color: SarakaColors.lightGray,
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
                              SarakaColors.lightRed),
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  );
                }

                return IconButton(
                  icon: Icon(Feather.getIconData('volume-2')),
                  color: SarakaColors.lightRed,
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
