import '../entities/article.dart';

export '../entities/article.dart';

mixin ArticleGettable {
  Future<List<Article>> getArticles();
}
