import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import '../blocs/article_gettable.dart';
import './prismic_io_article.dart';

class PrismicIoArticleRepository implements ArticleGettable {
  @override
  ValueObservable<List<Article>> getArticles() {
    final observable = BehaviorSubject<List<Article>>();

    const url =
        "https://saraka.cdn.prismic.io/api/v2/documents/search?ref=XMfh-RAAABUjzjv8";

    http.get(url).then((resopnce) {
      Map<String, dynamic> jsonData = jsonDecode(resopnce.body);

      if (jsonData['result'].hasData) {
        final articles = jsonData['result']
            .map((article) => PrismicIoArticle(article['data']));

        observable.add(articles);
      }
    });

    return observable;
  }
}
