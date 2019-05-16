import 'package:flutter/material.dart' show Material;
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import '../blocs/card_delete_bloc.dart';
import './disappearable_builder.dart';
import './processable_fancy_button.dart';

@immutable
class CardDeleteConfirmDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Consumer<CardDeleteBloc>(
          builder: (context, cardDeleteBloc) => Material(
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                clipBehavior: Clip.antiAlias,
                color: SarakaColors.white,
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
                          style: SarakaTextStyles.heading,
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          '"${cardDeleteBloc.card.text}" will be no longer in your flashcards and review progress will be deleted.',
                          style: SarakaTextStyles.multilineBody,
                        ),
                      ),
                      SizedBox(height: 24),
                      StreamBuilder(
                        stream: cardDeleteBloc.state,
                        initialData: cardDeleteBloc.state.value,
                        builder: (context, snapshot) => Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                DisappearableBuilder(
                                  isDisappeared: snapshot.requireData ==
                                      CardDeletionState.processing,
                                  curve: Curves.easeInOutCirc,
                                  child: ProcessableFancyButton(
                                    color: SarakaColors.white,
                                    onPressed: snapshot.requireData ==
                                            CardDeletionState.processing
                                        ? () {}
                                        : () {
                                            Navigator.of(context).pop();
                                          },
                                    child: Text("Cancel"),
                                  ),
                                ),
                                SizedBox(width: 16),
                                ProcessableFancyButton(
                                  color: SarakaColors.darkRed,
                                  isProcessing: snapshot.requireData ==
                                      CardDeletionState.processing,
                                  onPressed: () => cardDeleteBloc.delete(),
                                  child: Text("Delete"),
                                ),
                              ],
                            ),
                      ),
                    ],
                  ),
                ),
              ),
        ),
      );

  Future<bool> _onWillPop(BuildContext context) async {
    final cardDeleteBloc = Provider.of<CardDeleteBloc>(context);

    return cardDeleteBloc.state.value == CardDeletionState.initial;
  }
}
