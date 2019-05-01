import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../entities/article.dart';
import 'article_gettable.dart';
export '../entities/article.dart';

abstract class ArticleListBloc {
  ValueObservable<List<Article>> get articles;
}

class _ArticleListBloc implements ArticleListBloc {
  _ArticleListBloc({
    @required ArticleGettable articleGettable,
  })  : assert(articleGettable != null),
        _articleGettable = articleGettable {
    _articleGettable.getArticles().listen((ars) {
      articles.add(ars);
    });
  }

  final ArticleGettable _articleGettable;

  @override
  final BehaviorSubject<List<Article>> articles = BehaviorSubject();
}

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
