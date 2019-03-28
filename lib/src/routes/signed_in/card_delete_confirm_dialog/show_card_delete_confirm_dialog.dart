import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';
import './card_delete_confirm_dialog.dart';

void showCardDeleteConfirmDialog(BuildContext context, {@required Card card}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close',
    barrierColor: SarakaColors.darkBlack.withOpacity(0.666),
    transitionDuration: Duration(milliseconds: 300),
    transitionBuilder: (context, animation, secondaryAnimation, child) =>
        Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, 0.125),
              end: Offset(0, 0),
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOutCubic,
              ),
            ),
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.elasticInOut,
              ),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.5, end: 1).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOutCubic,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: child),
                ),
              ),
            ),
          ),
        ),
    pageBuilder: (context, _, __) => MultiProvider(
          providers: [
            Provider<CardDeleteBloc>(
              value:
                  Provider.of<CardDeleteBlocFactory>(context).create(card: card)
                    ..onComplete.listen((_) {
                      Navigator.of(context).pop();
                    })
                    ..onError.listen((error) {
                      print('error!');

                      Navigator.of(context).pop();
                    }),
            ),
          ],
          child: CardDeleteConfirmDialog(),
        ),
  );
}
