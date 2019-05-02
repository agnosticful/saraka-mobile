import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

class ArticleListItem extends StatelessWidget {
  ArticleListItem({
    @required String title,
    @required String image,
    @required String content,
  })  : assert(title != null),
        assert(image != null),
        assert(image != content),
        title = title,
        image = image,
        content = content;

  final String title;
  final String image;
  final String content;
  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Text(title),
          Image(
            image: NetworkImage(image),
          ),
          Text(content),
        ],
      );
}
