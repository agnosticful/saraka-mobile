import 'package:flutter/material.dart';
import 'package:saraka/constants.dart';
import 'package:provider/provider.dart';
import '../wave_background.dart';
import '../../blocs/article_list_bloc.dart';

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
                          : Container(
                              child: Text("No data"),
                            ),
                    ),
              ),
            ],
          ),
        ),
      );
}
