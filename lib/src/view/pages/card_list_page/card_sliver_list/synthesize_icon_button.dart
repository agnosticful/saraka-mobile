import 'package:flutter/material.dart' show IconButton;
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import '../../../../blocs/card_detail_bloc.dart';

class SynthesizeIconButton extends StatelessWidget {
  SynthesizeIconButton({@required this.text, Key key})
      : assert(text != null),
        super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Consumer<CardDetailBloc>(
      builder: (context, cardDetailBloc, _) => IconButton(
        icon: Icon(Feather.getIconData('volume-2')),
        iconSize: 24,
        color: SarakaColor.darkGray,
        onPressed: () => cardDetailBloc.speech(),
      ),
    );
  }
}
