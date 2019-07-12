import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/entities.dart';
import '../foundation/fancy_popup_dialog_route.dart';
import '../pages/card_confirm_deletion_dialog.dart';

class CardConfirmDeletionRoute extends FancyPopupDialogRoute<bool> {
  CardConfirmDeletionRoute({RouteSettings settings})
      : super(settings: settings);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      Consumer2<AuthenticationBloc, CardDeleteBlocFactory>(
        builder: (context, authenticationBloc, cardDeleteBlocFactory, _) =>
            StreamBuilder(
              stream: authenticationBloc.session,
              initialData: authenticationBloc.session.value,
              builder: (context, sessionSnapshot) => sessionSnapshot.hasData
                  ? MultiProvider(
                      providers: [
                        Provider<CardDeleteBloc>(
                          builder: (context) => cardDeleteBlocFactory.create(
                                card: (settings.arguments
                                        as CardConfirmDeletionRouteArguments)
                                    .card,
                                session: authenticationBloc.session.value,
                              )
                                ..onComplete.listen((_) {
                                  Navigator.of(context).pop(true);
                                })
                                ..onError.listen((error) {
                                  Navigator.of(context).pop(null);
                                }),
                        ),
                      ],
                      child: CardConfirmDeletionDialog(),
                    )
                  : Container(),
            ),
      );
}

class CardConfirmDeletionRouteArguments {
  CardConfirmDeletionRouteArguments({@required this.card})
      : assert(card != null);

  final Card card;
}
