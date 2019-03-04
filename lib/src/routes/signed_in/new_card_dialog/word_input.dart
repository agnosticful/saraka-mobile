import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/domains.dart';

class WordInput extends StatefulWidget {
  WordInput({Key key, @required this.newCard})
      : assert(newCard != null),
        super(key: key);

  final NewCard newCard;

  @override
  State<StatefulWidget> createState() => _WordInputState();
}

class _WordInputState extends State<WordInput> {
  final TextEditingController _controller = TextEditingController();

  VoidCallback _listener;

  Timer _timer;

  @override
  void initState() {
    super.initState();

    _listener = () {
      if (_timer != null) {
        _timer.cancel();
      }

      _timer = Timer(Duration(milliseconds: 500), () {
        widget.newCard.text = _controller.text;

        _timer = null;
      });
    };

    _controller.addListener(_listener);
  }

  @override
  void deactivate() {
    super.deactivate();

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
          suffixIcon: StreamBuilder<NewCard>(
            stream: widget.newCard.onChange,
            initialData: widget.newCard,
            builder: (context, snapshot) {
              if (!snapshot.requireData.isTextValid) {
                return Container(width: 0, height: 0);
              }

              if (!snapshot.requireData.isReadyToSynthesize) {
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
          ),
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

  void _onSoundPressed() {
    if (widget.newCard.isTextValid) {
      widget.newCard.synthesize();
    }
  }
}
