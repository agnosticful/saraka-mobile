import 'dart:math' show max;
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/domains.dart';
import './card_list_view_item.dart';

class CardListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cardList = Provider.of<CardList>(context);

    return StreamBuilder<CardList>(
      stream: cardList.onChange,
      initialData: cardList,
      builder: (context, snapshot) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Color(0x00000000),
              iconTheme: IconThemeData(color: SarakaColors.lightBlack),
              centerTitle: true,
              title: Text(
                'Cards',
                style: TextStyle(
                  color: SarakaColors.lightBlack,
                  fontFamily: SarakaFonts.rubik,
                ),
              ),
              leading: Navigator.of(context).canPop()
                  ? IconButton(
                      icon: Icon(Feather.getIconData('arrow-left')),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  : null,
              actions: [
                IconButton(
                  icon: Icon(Feather.getIconData('log-out')),
                  onPressed: () {
                    Provider.of<Authentication>(context).signOut();
                  },
                ),
              ],
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    return i.isEven
                        ? CardListViewItem(
                            card: snapshot.requireData.cards[i ~/ 2])
                        : SizedBox(height: 16);
                  },
                  childCount: max(0, snapshot.requireData.cards.length * 2 - 1),
                ),
              ),
            ),
          ],
        );

        // return ListView.separated(
        //   padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
        //   itemBuilder: (context, i) =>
        //       CardListViewItem(card: snapshot.requireData.cards[i]),
        //   separatorBuilder: (context, i) => SizedBox(
        //         height: 16,
        //       ),
        //   itemCount: snapshot.requireData.cards.length,
        // );
      },
    );
  }
}

// class CardList extends StatefulWidget {
//   CardList({Key key}) : super(key: key);

//   _CardListState createState() => _CardListState();
// }

// class _CardListState extends State<CardList> {
//   final CardList _cardList;

//   @override
//   Widget build(BuildContext context) {

//   }
// }
