import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:saraka/constants.dart';
import './card_list_page/card_sliver_list/card_sliver_list.dart';
import './card_list_page/new_card_floating_action_button.dart';
import '../widgets/wave_background.dart';

class CardListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          WaveBackground(color: SarakaColor.white),
          SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0x00000000),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: NewCardFloatingActionButton(),
              body: Container(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      elevation: 6,
                      backgroundColor: SarakaColor.white,
                      iconTheme: IconThemeData(color: SarakaColor.lightBlack),
                      centerTitle: true,
                      title: Text(
                        'Cards',
                        style: SarakaTextStyle.heading,
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
              ),
            ),
          ),
        ],
      );
}
