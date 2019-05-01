import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../blocs/article_list_bloc.dart';
import 'article_list_item.dart';

class ArticleListView extends StatefulWidget {
  @override
  _ArticleListView createState() => _ArticleListView();
}

class _ArticleListView extends State<ArticleListView> {
  @override
  Widget build(BuildContext context) => Consumer<ArticleListBloc>(
        builder: (context, articleListBloc) => StreamBuilder<List<Article>>(
              stream: articleListBloc.articles,
              initialData: articleListBloc.articles.value,
              builder: (context, snapshot) => snapshot.hasData
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate((context, i) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              border:
                                  Border.all(width: 1.0, color: Colors.orange)),
                          child: ArticleListItem({
                            title: snapshot.data[i].title,
                            image: snapshot.data[i].image,
                            content: snapshot.data[i].content
                          }),
                        );
                      }, childCount: snapshot.data.length),
                    )
                  : SliverFillRemaining(),
            ),
      );
}
