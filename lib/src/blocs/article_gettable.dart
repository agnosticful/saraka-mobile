import 'package:rxdart/rxdart.dart';
import '../entities/article.dart';

export '../entities/article.dart';

mixin ArticleGettable {
  ValueObservable<List<Article>> getArticles();
}
