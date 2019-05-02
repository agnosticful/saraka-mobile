import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_icons/flutter_icons.dart';
import 'package:saraka/constants.dart';
import '../wave_background.dart';
import 'article_list_view.dart';
=======
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import '../../blocs/article_list_bloc.dart';
import '../wave_background.dart';
>>>>>>> create-article-bloc

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
