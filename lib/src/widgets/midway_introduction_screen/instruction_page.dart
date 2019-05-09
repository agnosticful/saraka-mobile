import 'package:flutter/material.dart';

class InstructionPage extends StatelessWidget {
  InstructionPage({
    Key key,
    @required this.color,
    @required this.image,
    @required this.content,
  })  : assert(color != null),
        assert(image != null),
        assert(content != null),
        super(key: key);

  final Color color;

  final Widget image;

  final String content;

  @override
  Widget build(BuildContext context) => Container();
}
