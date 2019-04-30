import 'package:rxdart/rxdart.dart';
import 'package:saraka/entities.dart';

export 'package:saraka/entities.dart';

mixin ArticleGettable {
  ValueObservable<List<Article>> getArticles();
}
