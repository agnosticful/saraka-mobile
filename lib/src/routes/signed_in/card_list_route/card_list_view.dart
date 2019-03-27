import 'package:flutter/material.dart' show IconButton, SliverAppBar;
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';
import './card_sliver_list.dart';

class CardListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => CustomScrollView(
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
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
            sliver: CardSliverList(),
          ),
        ],
      );

  void _onSignOutPressed(BuildContext context) {
    Provider.of<AuthenticationBloc>(context).signOut();
  }
}
