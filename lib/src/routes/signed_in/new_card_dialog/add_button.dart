import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/widgets.dart';
import 'package:saraka/domains.dart';

class AddButton extends StatelessWidget {
  AddButton({@required this.newCard, Key key})
      : assert(newCard != null),
        super(key: key);

  final NewCard newCard;

  @override
  Widget build(BuildContext context) => Material(
        child: Floating(
          child: StreamBuilder<NewCard>(
            stream: newCard.onChange,
            initialData: newCard,
            builder: (context, snapshot) {
              final backgroundColor = snapshot.requireData.isReadyToSave
                  ? SarakaColors.darkCyan
                  : SarakaColors.darkGray;

              return InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => _onPressed(context),
                child: Container(
                  padding: EdgeInsets.fromLTRB(12, 12, 20, 12),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Feather.getIconData('feather'),
                        color: SarakaColors.white,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: SarakaFonts.rubik,
                          color: SarakaColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );

  void _onPressed(BuildContext context) {}
}
