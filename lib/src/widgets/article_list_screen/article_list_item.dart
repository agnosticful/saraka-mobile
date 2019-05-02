import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import './changeable_content.dart';

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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image(
              image: NetworkImage(image),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            child: Text(
              title,
              style: SarakaTextStyles.heading,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            child: ChangeableContent(
              content: content,
            ),
          ),
        ],
      );
}
