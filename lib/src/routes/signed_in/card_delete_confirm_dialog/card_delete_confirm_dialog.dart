import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/widgets.dart';

class CardDeleteConfirmDialog extends StatefulWidget {
  @override
  State<CardDeleteConfirmDialog> createState() =>
      _CardDeleteConfirmDialogState();
}

class _CardDeleteConfirmDialogState extends State<CardDeleteConfirmDialog>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  Animation _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: 0,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) => Consumer<CardDeleteBloc>(
        builder: (context, cardDeleteBloc) => Material(
              shape: SuperellipseShape(borderRadius: BorderRadius.circular(24)),
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
                        style: TextStyle(
                          color: SarakaColors.darkBlack,
                          fontFamily: SarakaFonts.rubik,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        '"${cardDeleteBloc.card.text}" will be no longer in your flashcards and study progress will be deleted.',
                        style: TextStyle(
                          color: SarakaColors.darkGray,
                          fontFamily: SarakaFonts.rubik,
                          fontSize: 14,
                          decoration: TextDecoration.none,
                          height: 1.25,
                        ),
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
      );
}
