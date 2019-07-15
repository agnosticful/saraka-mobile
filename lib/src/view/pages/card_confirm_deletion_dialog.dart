import 'package:flutter/material.dart' hide Card;
import 'package:saraka/constants.dart';
import 'package:saraka/entities.dart';
import 'package:saraka/widgets.dart';

@immutable
class CardConfirmDeletionDialog extends StatelessWidget {
  CardConfirmDeletionDialog({@required this.card, Key key}) : super(key: key);

  final Card card;

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: Material(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.antiAlias,
          color: SarakaColor.white,
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    'Delete the card?',
                    style: SarakaTextStyle.heading,
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    '"${card.text}" will be no longer in your flashcards and review progress will be deleted.',
                    style: SarakaTextStyle.multilineBody,
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProcessableFancyButton(
                      color: SarakaColor.white,
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text("Cancel"),
                    ),
                    SizedBox(width: 16),
                    ProcessableFancyButton(
                      color: SarakaColor.darkRed,
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text("Delete"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
