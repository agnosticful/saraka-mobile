import 'dart:math' show max;
import 'package:flutter/material.dart' show IconButton, SliverAppBar;
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/domains.dart';
import 'package:saraka/usecases.dart';
import './card_list_view_item.dart';

class CardListView extends StatefulWidget {
  State<CardListView> createState() => _CardListViewState();
}

class _CardListViewState extends State<CardListView> {
  CardList _cardList;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final authentication = Provider.of<Authentication>(context);
      final cardListUsecase = Provider.of<CardListUsecase>(context);
      final cardList = await cardListUsecase(authentication.user);

      setState(() {
        _cardList = cardList;
      });
    });
  }

  @override
  Widget build(BuildContext context) => _cardList == null
      ? Container()
      : StreamBuilder<List<Card>>(
          stream: _cardList.cards,
          initialData: [],
          builder: (context, snapshot) => CustomScrollView(
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
                                  card: snapshot.requireData[i ~/ 2])
                              : SizedBox(height: 16);
                        },
                        childCount: max(0, snapshot.requireData.length * 2 - 1),
                      ),
                    ),
                  ),
                ],
              ),
        );
}
