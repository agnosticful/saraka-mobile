import 'package:flutter/material.dart' hide Card;
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:saraka/constants.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import './dashboard_gridview_item.dart';
import './main_drawer.dart';
import './start_learning_floating_action_button.dart';
import './wave_background.dart';

class DashboardScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Color(0x00000000),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    floatingActionButton: StartLearningFloatingActionButton(),
    appBar: AppBar(
      title: Text(
        'Dashboard',
        style: TextStyle(
          color: SarakaColors.white,
          fontFamily: SarakaFonts.rubik,
        ),
      ),
      centerTitle: true,
      backgroundColor: SarakaColors.lightBlack,
      elevation: 0,
      iconTheme: IconThemeData(color: SarakaColors.white),
    ),
    drawer: MainDrawer(),
    body: Consumer<CardListBloc>(
        builder: (context, cardListBloc) => Container(
        child: StreamBuilder<List<Card>>(
          stream: cardListBloc.cards.map((iter) => iter.toList()),
          builder: (context, snapshot) => Stack(
            children: <Widget>[
              WaveBackground(),
              StaggeredGridView.count(
                crossAxisCount: 1,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                
                children: <Widget>[
                  CardsMaturityGridViewItem(
                    totalCardsNumber: snapshot.data.length.toString(),
                    todayLearnNumber: snapshot.data.where((iter) => 
                      iter.nextStudyScheduledAt.isBefore(DateTime.now())).length.toString(),
                    maturedCardNumber: 62.3
                  ),
                ],
                staggeredTiles: [
                  StaggeredTile.extent(1, 350.0),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}