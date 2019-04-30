import './../entities/article.dart';

class PrismicIoArticle extends Article {
  PrismicIoArticle(Map<String, dynamic> article)
      : assert(article != null),
        title = article['title']['text'],
        image = article['image']['url'],
        content = article['content'];

  @override
  final String title;

  @override
  final String image;

  @override
  final String content;
}
