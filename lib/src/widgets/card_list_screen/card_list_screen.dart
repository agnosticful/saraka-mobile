import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/widgets.dart';
import './card_sliver_list.dart';
import './new_card_floating_action_button.dart';

class CardListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: NewCardFloatingActionButton(),
        body: Container(
          child: Stack(
            children: [
              WaveBackground(color: SarakaColors.white),
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    elevation: 6,
                    backgroundColor: SarakaColors.white,
                    iconTheme: IconThemeData(color: SarakaColors.lightBlack),
                    centerTitle: true,
                    title: Text(
                      'Cards',
                      style: SarakaTextStyles.appBarTitle.copyWith(
                        color: SarakaColors.lightBlack,
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
              ),
            ],
          ),
        ),
      );
}
