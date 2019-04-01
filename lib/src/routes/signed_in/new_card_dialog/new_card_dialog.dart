import 'package:flutter/material.dart';
import 'package:saraka/constants.dart';
import './add_button.dart';
import './synthesize_button.dart';
import './word_input.dart';

class NewCardDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Material(
        shape: SuperellipseShape(
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
        color: SarakaColors.white,
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
