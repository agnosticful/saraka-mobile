import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../blocs/authentication_bloc.dart';
import '../blocs/card_delete_bloc.dart';
import '../entities/card.dart';
import './card_delete_confirm_dialog.dart';
import './fancy_popup_dialog.dart';

Future<bool> showCardDeleteConfirmDialog({
  @required context,
  @required Card card,
}) async {
  assert(context != null);

  return await Navigator.of(context)
      .push<bool>(CardDeleteConfirmDialogRoute(card: card));
}

class CardDeleteConfirmDialogRoute extends FancyPopupDialogRoute<bool> {
  CardDeleteConfirmDialogRoute({@required Card card})
      : assert(card != null),
        _card = card;

  final Card _card;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      Consumer2<AuthenticationBloc, CardDeleteBlocFactory>(
        builder: (context, authenticationBloc, cardDeleteBlocFactory) =>
            MultiProvider(
              providers: [
                Provider<CardDeleteBloc>(
                  value: cardDeleteBlocFactory.create(
                    card: _card,
                    session: authenticationBloc.session,
                  )
                    ..onComplete.listen((_) {
                      Navigator.of(context).pop(true);
                    })
                    ..onError.listen((error) {
                      Navigator.of(context).pop(null);
                    }),
                ),
              ],
              child: CardDeleteConfirmDialog(),
            ),
      );
}
