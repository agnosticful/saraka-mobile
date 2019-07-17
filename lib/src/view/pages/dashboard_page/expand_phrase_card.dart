import 'package:flutter/material.dart' show Material;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import '../../../blocs/authentication_bloc.dart';
import '../../../bloc_factories/card_create_bloc_factory.dart';
import '../../widgets/fancy_snack_bar.dart';
import '../../widgets/processable_fancy_button.dart';

class ExpandPhraseCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Material(
        elevation: 16,
        shadowColor: SarakaColor.lightBlack.withOpacity(0.1),
        color: Color(0xffffffff),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/card-writing.png",
                    width: 64,
                    height: 64,
                  ),
                  SizedBox(width: 16),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Expand your phrases",
                          style: SarakaTextStyle.heading,
                        ),
                        SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: ShapeDecoration(
                                    shape: CircleBorder(),
                                    color: SarakaColor.darkGray,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Phrases you heard today",
                                  style: SarakaTextStyle.body2,
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: ShapeDecoration(
                                    shape: CircleBorder(),
                                    color: SarakaColor.darkGray,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Phrases related on your job or major",
                                  style: SarakaTextStyle.body2,
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: ShapeDecoration(
                                    shape: CircleBorder(),
                                    color: SarakaColor.darkGray,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Useful phrases at cafe or restaurants",
                                  style: SarakaTextStyle.body2,
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ProcessableFancyButton(
                    color: SarakaColor.lightRed,
                    child: Text("Add New"),
                    onPressed: () => _onCardAddButtonPressed(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  _onCardAddButtonPressed(BuildContext context) async {
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
