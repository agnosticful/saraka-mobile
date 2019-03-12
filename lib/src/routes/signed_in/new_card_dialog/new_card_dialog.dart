import 'package:flutter/material.dart';
import 'package:saraka/constants.dart';
import './add_button.dart';
import './word_input.dart';

class NewCardDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Material(
          shape: SuperellipseShape(borderRadius: BorderRadius.circular(24)),
          clipBehavior: Clip.antiAlias,
          color: SarakaColors.white,
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Card',
                  style: TextStyle(
                    color: SarakaColors.darkBlack,
                    fontFamily: SarakaFonts.rubik,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: WordInput(),
                    ),
                    SizedBox(width: 16),
                    AddButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
