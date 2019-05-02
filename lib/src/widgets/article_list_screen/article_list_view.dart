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
                        final itemIndex = i ~/ 2;
                        return i.isEven
                            ? Material(
                                shape: SuperellipseShape(
                                    borderRadius: BorderRadius.circular(24)),
                                color: Color(0xffffffff),
                                child: ArticleListItem(
                                  title: snapshot.data[itemIndex].title,
                                  image: snapshot.data[itemIndex].image,
                                  content: snapshot.data[itemIndex].content,
                                ),
                              )
                            : SizedBox(
                                height: 16,
                              );
                      }, childCount: snapshot.data.length),
                    )
                  : SliverFillRemaining(),
            ),
      );
}
