import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/domains.dart';

class AddButton extends StatefulWidget {
  AddButton({@required this.newCard, Key key})
      : assert(newCard != null),
        super(key: key);

  final NewCard newCard;

  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  bool _isAdding = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NewCard>(
      stream: widget.newCard.onChange,
      initialData: widget.newCard,
      builder: (context, snapshot) => _isAdding
          ? RaisedButton(
              shape: SuperellipseShape(borderRadius: BorderRadius.circular(24)),
              onPressed: null,
              color: SarakaColors.darkCyan,
              textColor: SarakaColors.white,
              splashColor: SarakaColors.lightCyan,
              // highlightColor: SarakaColors.lightCyan,
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
            )
          : RaisedButton.icon(
              shape: SuperellipseShape(borderRadius: BorderRadius.circular(24)),
              onPressed: snapshot.requireData.isReadyToSave
                  ? () => _onPressed(context)
                  : null,
              icon: Icon(Feather.getIconData('plus')),
              color: SarakaColors.darkCyan,
              textColor: SarakaColors.white,
              splashColor: SarakaColors.lightCyan,
              // highlightColor: SarakaColors.lightCyan,
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

  void _onPressed(BuildContext context) async {
    assert(widget.newCard.isReadyToSave);

    setState(() {
      _isAdding = true;
    });

    try {
      await widget.newCard.save();

      Navigator.of(context).pop();
    } on NewCardDuplicationException catch (_) {
      setState(() {
        _isAdding = false;
      });
    }
  }
}
