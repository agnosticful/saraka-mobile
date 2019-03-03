import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/domains.dart';
import 'package:saraka/widgets.dart';

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
      child: Floating(
        child: Container(
          decoration: BoxDecoration(
            color: SarakaColors.darkWhite,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'word...',
              hintStyle: TextStyle(
                fontSize: 16,
                fontFamily: SarakaFonts.rubik,
                color: SarakaColors.darkGray,
              ),
              contentPadding: EdgeInsets.only(
                top: 16,
                bottom: 16,
                left: 16,
              ),
              border: InputBorder.none,
              suffixIcon: StreamBuilder<NewCard>(
                stream: widget.newCard.onChange,
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.requireData.text.length == 0) {
                    return Container(width: 0, height: 0);
                  }

                  Icon icon;
                  VoidCallback onPressed;

                  if (snapshot.requireData.isReadyToSynthesize) {
                    icon = Icon(Feather.getIconData('volume-2'));
                    onPressed = _onSoundPressed;
                  } else {
                    icon = Icon(Feather.getIconData('loader'));
                  }

                  return IconButton(
                    icon: icon,
                    color: SarakaColors.darkCyan,
                    disabledColor: SarakaColors.darkGray,
                    onPressed: onPressed,
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
        ),
      ),
    );
  }

  void _onSoundPressed() {
    widget.newCard.synthesize();
  }
}
