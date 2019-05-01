import 'package:flutter/material.dart' hide Card;
import 'package:saraka/constants.dart';
import 'package:saraka/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';

class ArticleListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          child: Stack(
            children: <Widget>[
              WaveBackground(color: SarakaColors.white),
              Consumer<ArticleListBloc>(
                builder: (context, articleListBloc) =>
                    StreamBuilder<List<Article>>(
                      stream: articleListBloc.articles,
                      initialData: articleListBloc.articles.value,
                      builder: (context, snapshot) => snapshot.hasData
                          ? Container(
                              child: Text(snapshot.data[0].title),
                            )
                          : Container(),
                    ),
              ),
            ],
          ),
        ),
      );
}
