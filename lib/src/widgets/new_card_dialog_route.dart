import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/authentication_bloc.dart';
import '../blocs/card_list_bloc.dart';
import '../blocs/card_create_bloc.dart';
import '../blocs/synthesizer_bloc.dart';
import './fancy_popup_dialog.dart';
import './new_card_dialog.dart';

Future<bool> showNewCardDialog({@required context}) async {
  assert(context != null);

  return await Navigator.of(context).push<bool>(NewCardDialogRoute());
}

class NewCardDialogRoute extends FancyPopupDialogRoute<bool> {
  NewCardDialogRoute({RouteSettings settings}) : super(settings: settings);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      Consumer4<AuthenticationBloc, CardCreateBlocFactory, CardListBlocFactory,
          SynthesizerBlocFactory>(
        builder: (
          context,
          authenticationBloc,
          cardCreateBlocFactory,
          cardListBlocFactory,
          synthesizerBlocFactory,
        ) =>
            MultiProvider(
              providers: [
                StatefulProvider<CardListBloc>(
                  valueBuilder: (_) => cardListBlocFactory.create(
                        session: authenticationBloc.session,
                      ),
                ),
                StatefulProvider<CardCreateBloc>(
                  valueBuilder: (_) => cardCreateBlocFactory.create(
                        session: authenticationBloc.session,
                      )
                        ..initialize()
                        ..onComplete.listen((_) {
                          Navigator.of(context).pop(true);
                        })
                        ..onError.listen((error) {
                          Navigator.of(context).pop(null);
                        }),
                ),
                StatefulProvider<SynthesizerBloc>(
                  valueBuilder: (_) => synthesizerBlocFactory.create(),
                ),
              ],
              child: NewCardDialog(),
            ),
      );
}
