import 'package:flutter/material.dart' hide Card;
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:saraka/constants.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/widgets.dart';
import './main_drawer.dart';
import './start_learning_floating_action_button.dart';
import './summary.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          WaveBackground(color: SarakaColors.white),
          Scaffold(
            backgroundColor: Color(0x00000000),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: StartLearningFloatingActionButton(),
            appBar: AppBar(
              title: Text('Dashboard',
                  style: SarakaTextStyles.appBarTitle
                      .copyWith(color: SarakaColors.lightBlack)),
              centerTitle: true,
              backgroundColor: Color(0x00000000),
              elevation: 0,
              iconTheme: IconThemeData(color: SarakaColors.lightBlack),
              actions: [
                IconButton(
                  icon: Icon(Feather.getIconData('inbox')),
                  onPressed: () => showNewCardDialog(context: context),
                ),
              ],
            ),
            drawer: MainDrawer(),
            body: Consumer<CardListBloc>(
              builder: (context, cardListBloc) => Container(
                    child: StreamBuilder<List<Card>>(
                      stream: cardListBloc.cards.map((iter) => iter.toList()),
                      initialData: [],
                      builder: (context, snapshot) => Stack(
                            children: <Widget>[
                              WaveBackground(color: SarakaColors.white),
                              Summary(
                                totalCardsNumber: snapshot.requireData.length,
                                todayLearnNumber: snapshot.requireData
                                    .where((iter) => iter.nextReviewScheduledAt
                                        .isBefore(DateTime.now()))
                                    .length
                                    .toString(),
                                cardsMaturity: snapshot.requireData.toList(),
                              )
                            ],
                          ),
                    ),
                  ),
            ),
          )
        ],
      );
}
