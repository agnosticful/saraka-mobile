import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import '../foundation/fancy_popup_dialog_route.dart';
import '../pages/card_create_dialog.dart';

class CardCreateRoute extends FancyPopupDialogRoute<bool> {
  CardCreateRoute({RouteSettings settings}) : super(settings: settings);

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
          _,
        ) =>
            StreamBuilder(
              stream: authenticationBloc.session,
              initialData: authenticationBloc.session.value,
              builder: (context, sessionSnapshot) => sessionSnapshot.hasData
                  ? MultiProvider(
                      providers: [
                        Provider<CardListBloc>(
                          builder: (_) => cardListBlocFactory.create(
                                session: authenticationBloc.session.value,
                              ),
                        ),
                        Provider<CardCreateBloc>(
                          builder: (_) => cardCreateBlocFactory.create(
                                session: authenticationBloc.session.value,
                              )
                                ..initialize()
                                ..onComplete.listen((_) {
                                  Navigator.of(context).pop(true);
                                })
                                ..onError.listen((error) {
                                  Navigator.of(context).pop(null);
                                }),
                        ),
                        Provider<SynthesizerBloc>(
                          builder: (_) => synthesizerBlocFactory.create(),
                        ),
                      ],
                      child: CardCreateDialog(),
                    )
                  : Container(),
            ),
      );
}
