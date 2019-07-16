import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/widgets.dart';

class AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<NewCardEditBloc>(
        builder: (context, newCardEditBloc, _) => StreamBuilder<bool>(
          stream: newCardEditBloc.isTextValid,
          initialData: newCardEditBloc.isTextValid.value,
          builder: (_, snapshot) => ProcessableFancyButton(
            color: SarakaColor.darkRed,
            isDisabled: !snapshot.requireData,
            onPressed: () =>
                Navigator.of(context).pop(newCardEditBloc.text.value),
            child: Text("Add"),
          ),
        ),
      );
}
