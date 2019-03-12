import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';

class AddButton extends StatefulWidget {
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  CardAdderBloc _cardAdderBloc;

  bool _isAdding = false;

  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final cardAdderBloc = Provider.of<CardAdderBloc>(context);

      _subscription = cardAdderBloc.state.listen((state) {
        if (state == CardAddingState.completed) {
          Navigator.of(context).pop();
        }

        if (state == CardAddingState.failed) {
          print('dame');

          setState(() {
            _isAdding = false;
          });
        }
      });

      setState(() {
        _cardAdderBloc = cardAdderBloc;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cardAdderBloc == null || _isAdding) {
      return RaisedButton(
        shape: SuperellipseShape(borderRadius: BorderRadius.circular(24)),
        onPressed: null,
        color: SarakaColors.darkCyan,
        textColor: SarakaColors.white,
        splashColor: SarakaColors.lightCyan,
        disabledColor: SarakaColors.lightGray,
        disabledTextColor: SarakaColors.darkGray,
        elevation: 6,
        child: Container(
          padding: EdgeInsets.all(14),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(SarakaColors.darkGray),
            ),
          ),
        ),
      );
    }

    return StreamBuilder<NewCardText>(
      stream: _cardAdderBloc.text,
      initialData: _cardAdderBloc.text.value,
      builder: (context, snapshot) => RaisedButton.icon(
            shape: SuperellipseShape(borderRadius: BorderRadius.circular(24)),
            onPressed: snapshot.requireData.isValid ? () => _onPressed() : null,
            icon: Icon(Feather.getIconData('plus')),
            color: SarakaColors.darkCyan,
            textColor: SarakaColors.white,
            splashColor: SarakaColors.lightCyan,
            disabledColor: SarakaColors.lightGray,
            disabledTextColor: SarakaColors.darkGray,
            textTheme: ButtonTextTheme.primary,
            elevation: 6,
            label: Container(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text(
                'Add',
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: SarakaFonts.rubik,
                ),
              ),
            ),
          ),
    );
  }

  void _onPressed() async {
    setState(() {
      _isAdding = true;
    });

    _cardAdderBloc.save();
  }
}
