import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/constants.dart';
import 'package:tuple/tuple.dart';
import '../../../blocs/new_card_edit_bloc.dart';

class SynthesizeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<NewCardEditBloc>(
        builder: (context, newCardEditBloc, _) =>
            StreamBuilder<Tuple2<bool, bool>>(
          stream: Observable.combineLatest2(
            newCardEditBloc.isTextValid,
            newCardEditBloc.isSpeechSoundLoaded,
            (a, b) => Tuple2(a, b),
          ),
          initialData: Tuple2(
            newCardEditBloc.isTextValid.value,
            newCardEditBloc.isSpeechSoundLoaded.value,
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData || !snapshot.requireData.item1) {
              return IconButton(
                icon: Icon(Feather.getIconData('volume-2')),
                color: SarakaColor.lightGray,
                onPressed: null,
              );
            } else if (!snapshot.requireData.item2) {
              return SizedBox.fromSize(
                size: Size.square(48),
                child: Center(
                  child: SizedBox.fromSize(
                    size: Size.square(20),
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(SarakaColor.lightRed),
                      strokeWidth: 2,
                    ),
                  ),
                ),
              );
            } else {
              return IconButton(
                icon: Icon(Feather.getIconData('volume-2')),
                color: SarakaColor.lightRed,
                onPressed: () => newCardEditBloc.speech(),
              );
            }
          },
        ),
      );
}
