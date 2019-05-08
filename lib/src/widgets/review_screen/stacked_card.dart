import 'package:flutter/material.dart' hide Card;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import '../../blocs/card_review_bloc.dart';
import '../../blocs/synthesizer_bloc.dart';

@immutable
class StackedCard extends StatelessWidget {
  const StackedCard({Key key, @required Card card})
      : assert(card != null),
        _card = card,
        super(key: key);

  final Card _card;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shape: SuperellipseShape(
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      color: SarakaColors.white,
      child: InkWell(
        onTap: () => _onTap(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Icon(
              Feather.getIconData('volume-2'),
              color: SarakaColors.darkWhite,
              size: 96,
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    Provider.of<SynthesizerBloc>(context).play(_card.text);
  }
}
