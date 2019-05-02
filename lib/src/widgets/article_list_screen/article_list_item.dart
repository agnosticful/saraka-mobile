import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';

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
          Text(
            title,
            style: SarakaTextStyles.heading,
          ),
          Image(
            image: NetworkImage(image),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              content,
              style: SarakaTextStyles.body,
            ),
          ),
        ],
      );
}
