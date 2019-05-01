import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/widgets.dart';
import 'article_list_view.dart';

class ArticleListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          child: Stack(
            children: <Widget>[
              WaveBackground(color: SarakaColors.white),
              CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    floating: true,
                    elevation: 6,
                    backgroundColor: SarakaColors.white,
                    iconTheme: IconThemeData(color: SarakaColors.lightBlack),
                    centerTitle: true,
                    title: Text(
                      'Articles',
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
                    sliver: ArticleListView(),
                  ),
                ],
              )
            ],
          ),
        ),
      );
}
