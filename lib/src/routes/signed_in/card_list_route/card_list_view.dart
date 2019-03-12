import 'dart:math' show max;
import 'package:flutter/material.dart' show IconButton, SliverAppBar;
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';
import './card_list_view_item.dart';

class CardListView extends StatefulWidget {
  State<CardListView> createState() => _CardListViewState();
}

class _CardListViewState extends State<CardListView> {
  CardListBloc _cardListBloc;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final cardListBloc = Provider.of<CardListBloc>(context);

      setState(() {
        _cardListBloc = cardListBloc;
      });
    });
  }

  @override
  Widget build(BuildContext context) => _cardListBloc == null
      ? Container()
      : StreamBuilder<List<Card>>(
          stream: _cardListBloc.cards.map((iter) => iter.toList()),
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
                        onPressed: () => _onSignOutPressed(context),
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

  void _onSignOutPressed(BuildContext context) {
    Provider.of<AuthenticationBloc>(context).signOut();
  }
}
