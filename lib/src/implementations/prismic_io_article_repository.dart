import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/blocs.dart';
import './prismic_io_article.dart';

class PrismicIoArticleRepository implements ArticleGettable {
  @override
  ValueObservable<List<Article>> getArticles() {
    final observable = BehaviorSubject<List<Article>>();

    const url =
        "https://saraka.cdn.prismic.io/api/v2/documents/search?ref=XMfh-RAAABUjzjv8";

    Map<String, dynamic> jsonData = jsonDecode(url);

    if (jsonData['result'].hasData) {
      final articles = jsonData['result']
          .map((article) => PrismicIoArticle(article['data']));

      observable.add(articles);
    }

    return observable;
  }
}
