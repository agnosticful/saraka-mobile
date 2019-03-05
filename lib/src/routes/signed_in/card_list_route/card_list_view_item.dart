import 'dart:ui';
import 'package:flutter/material.dart' show InkWell, Material;
import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/domains.dart';

class CardListViewItem extends StatelessWidget {
  CardListViewItem({Key key, @required this.card})
      : assert(card != null),
        super(key: key);

  final Card card;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: SuperellipseShape(borderRadius: BorderRadius.circular(24)),
      elevation: 6,
      shadowColor: SarakaColors.darkGray.withOpacity(0.25),
      clipBehavior: Clip.antiAlias,
      color: Color(0xffffffff),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(16),
          child: Text(
            card.text,
            style: TextStyle(
              color: SarakaColors.lightBlack,
              fontSize: 16,
              fontFamily: SarakaFonts.rubik,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }
}
