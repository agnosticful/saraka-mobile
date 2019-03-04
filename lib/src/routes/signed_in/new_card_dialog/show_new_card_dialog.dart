import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/domains.dart';
import 'package:saraka/usecases.dart';
import './new_card_dialog.dart';

void showNewCardDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, _, __) {
      final authentication = Provider.of<Authentication>(context);

      return StreamBuilder<User>(
        stream: authentication.onUserChange,
        initialData: authentication.user,
        builder: (context, snapshot) => NewCardDialog(
              newCard:
                  Provider.of<NewCardUsecase>(context)(snapshot.requireData),
            ),
      );
    },
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
                  child: child,
                ),
              ),
            ),
          ),
        ),
  );
}
