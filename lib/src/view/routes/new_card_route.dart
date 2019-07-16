import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import '../foundation/fancy_popup_dialog_route.dart';
import '../pages/new_card_dialog.dart';

class NewCardRoute extends FancyPopupDialogRoute<String> {
  NewCardRoute({RouteSettings settings}) : super(settings: settings);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      Consumer2<AuthenticationBloc, NewCardEditBlocFactory>(
        builder: (
          context,
          authenticationBloc,
          newCardEditBlocFactory,
          _,
        ) =>
            StreamBuilder(
          stream: authenticationBloc.session,
          initialData: authenticationBloc.session.value,
          builder: (context, sessionSnapshot) => sessionSnapshot.hasData
              ? Provider<NewCardEditBloc>(
                  key: ObjectKey(sessionSnapshot.requireData),
                  builder: (_) => newCardEditBlocFactory.create()..initialize(),
                  dispose: (_, newCardEditBloc) => newCardEditBloc.dispose(),
                  child: NewCardDialog(),
                )
              : Container(),
        ),
      );
}
