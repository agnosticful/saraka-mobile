import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/widgets.dart';
import '../../blocs/card_adder_bloc.dart';

class AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CardAdderBloc>(
      builder: (context, cardAdderBloc) => StreamBuilder<CardAddingState>(
            stream: cardAdderBloc.state,
            initialData: cardAdderBloc.state.value,
            builder: (context, stateSnapshot) => StreamBuilder<NewCardText>(
                  stream: cardAdderBloc.text,
                  initialData: cardAdderBloc.text.value,
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
    final cardAdderBloc = Provider.of<CardAdderBloc>(context);

    cardAdderBloc.save();
  }
}
