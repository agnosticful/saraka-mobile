import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import '../../../blocs/authentication_bloc.dart';
import '../../../bloc_factories/card_create_bloc_factory.dart';
import '../../widgets/fancy_snack_bar.dart';

class NewCardFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FloatingActionButton.extended(
        backgroundColor: SarakaColor.lightRed,
        foregroundColor: SarakaColor.white,
        icon: Icon(Feather.getIconData('plus')),
        label: Text(
          'New Card',
          style: SarakaTextStyle.body.copyWith(color: SarakaColor.white),
        ),
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(24)),
        onPressed: () => _onPressed(context),
      );

  void _onPressed(BuildContext context) async {
    final authenticationBloc = Provider.of<AuthenticationBloc>(context);
    final cardCreateBlocFactory = Provider.of<CardCreateBlocFactory>(context);
    final cardCreateBloc = cardCreateBlocFactory.create(
      session: authenticationBloc.session.value,
    )..initialize();

    final text = await Navigator.of(context).pushNamed("/cards:new");

    if (text != null) {
      Scaffold.of(context).showSnackBar(FancySnackBar(
        content: Text("Adding \"$text\"..."),
      ));

      await cardCreateBloc.create(text);

      Scaffold.of(context).showSnackBar(FancySnackBar(
        content: Text("\"$text\" has been added!"),
      ));
    }

    cardCreateBloc.dispose();
  }
}
