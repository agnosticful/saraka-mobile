import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show IconButton;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import '../../blocs/card_review_bloc.dart';

class BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<CardReviewBloc>(
        builder: (context, cardReviewBloc) => StreamBuilder(
              stream: cardReviewBloc.canUndo,
              initialData: false,
              builder: (context, snapshot) => IconButton(
                    icon: Icon(Feather.getIconData('corner-up-left')),
                    color: SarakaColors.white,
                    disabledColor: SarakaColors.darkGray,
                    onPressed:
                        snapshot.requireData ? () => _onPressed(context) : null,
                  ),
            ),
      );

  void _onPressed(BuildContext context) {
    final cardReviewBloc = Provider.of<CardReviewBloc>(context);

    cardReviewBloc.undo();
  }
}
