import 'package:flutter/material.dart';
import 'package:saraka/constants.dart';
import './new_card_dialog/add_button.dart';
import './new_card_dialog/synthesize_button.dart';
import './new_card_dialog/word_input.dart';

@immutable
class NewCardDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Material(
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        clipBehavior: Clip.antiAlias,
        color: SarakaColor.white,
        elevation: 6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WordInput(),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 8),
                    child: SynthesizeButton(),
                  ),
                  Expanded(child: Container()),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16, right: 16),
                    child: AddButton(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
