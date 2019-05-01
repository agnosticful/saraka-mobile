import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/entities.dart';
import 'article_gettable.dart';

export 'article_gettable.dart';

class ArticleListBlocFactory {
  ArticleListBlocFactory({
    @required ArticleGettable articleGettable,
  })  : assert(articleGettable != null),
        _articleGettable = articleGettable;

  final ArticleGettable _articleGettable;

  ArticleListBloc create() => _ArticleListBloc(
        articleGettable: _articleGettable,
      );
}

abstract class ArticleListBloc {
  ValueObservable<List<Article>> get articles;
}

class _ArticleListBloc implements ArticleListBloc {
  _ArticleListBloc({
    @required ArticleGettable articleGettable,
  })  : assert(articleGettable != null),
        _articleGettable = articleGettable {
    _articleGettable.getArticles().listen((article) {
      articles.add(article);
    });
