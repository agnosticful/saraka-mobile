import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';
import './add_button.dart';
import './synthesize_button.dart';
import './word_input.dart';

class NewCardDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Material(
        shape: SuperellipseShape(
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
        color: SarakaColors.white,
        elevation: 6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WordInput(),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 8),
                    child: SynthesizeButton(),
                  ),
                  Expanded(child: Container()),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16, right: 16),
                    child: AddButton(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  static void show(BuildContext context) {
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
              StatefulProvider<CardListBloc>(
                valueBuilder: (_) =>
                    Provider.of<CardListBlocFactory>(context).create(),
              ),
              StatefulProvider<CardAdderBloc>(
                valueBuilder: (_) =>
                    Provider.of<CardAdderBlocFactory>(context).create()
                      ..initialize()
                      ..onComplete.listen((_) {
                        Navigator.of(context).pop();
                      })
                      ..onError.listen((error) {
                        Navigator.of(context).pop();
                      }),
              ),
              StatefulProvider<SynthesizerBloc>(
                valueBuilder: (_) =>
                    Provider.of<SynthesizerBlocFactory>(context).create(),
              ),
            ],
            child: NewCardDialog(),
          ),
    );
  }
}
