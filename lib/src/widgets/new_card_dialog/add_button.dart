import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import '../../blocs/card_create_bloc.dart';
import '../processable_fancy_button.dart';

class AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CardCreateBloc>(
      builder: (context, cardCreateBloc) => StreamBuilder<CardAddingState>(
            stream: cardCreateBloc.state,
            initialData: cardCreateBloc.state.value,
            builder: (context, stateSnapshot) => StreamBuilder<NewCardText>(
                  stream: cardCreateBloc.text,
                  initialData: cardCreateBloc.text.value,
                  builder: (context, textSnapshot) => ProcessableFancyButton(
                        color: SarakaColors.darkRed,
                        isProcessing: stateSnapshot.requireData ==
                            CardAddingState.processing,
                        isDisabled: !textSnapshot.requireData.isValid,
                        onPressed: () => _onPressed(context),
                        child: Text("Add"),
                      ),
                ),
          ),
    );
  }

  void _onPressed(BuildContext context) {
    final cardCreateBloc = Provider.of<CardCreateBloc>(context);

    cardCreateBloc.save();
  }
}
