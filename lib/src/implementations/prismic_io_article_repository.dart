import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../blocs/article_gettable.dart';
import '../entities/article.dart';
import './prismic_io_article.dart';

class PrismicIoArticleRepository implements ArticleGettable {
  PrismicIoArticleRepository({@required String prismicIoArticleUrl})
      : assert(prismicIoArticleUrl != null),
        prismicIoArticleUrl = prismicIoArticleUrl;

  final prismicIoArticleUrl;

  @override
  ValueObservable<List<Article>> getArticles() {
    final observable = BehaviorSubject<List<Article>>();

    http.get(prismicIoArticleUrl).then((resopnce) {
      Map<String, dynamic> jsonData = jsonDecode(resopnce.body);

      final articles = (jsonData['results'] as List)
          .map((result) => PrismicIoArticle(result['data']))
          .toList();

      observable.add(articles);
    });

    return observable;
  }
}
