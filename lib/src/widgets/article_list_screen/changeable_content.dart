import 'package:flutter/material.dart';
import '../../../constants.dart';

class ChangeableContent extends StatefulWidget {
  ChangeableContent({@required String content})
      : assert(content != null),
        content = content;

  final String content;

  @override
  _ChangeableContent createState() => _ChangeableContent();
}

class _ChangeableContent extends State<ChangeableContent> {
  String firstHalf;
  String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.content.length > 50) {
      firstHalf = widget.content.substring(0, 50);
      secondHalf = widget.content.substring(50, widget.content.length);
    } else {
      firstHalf = widget.content;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) => secondHalf.isEmpty
      ? Text(
          firstHalf,
          style: SarakaTextStyles.body,
        )
      : Column(
          children: <Widget>[
            new Text(
              flag ? (firstHalf + "...") : (firstHalf + secondHalf),
              style: SarakaTextStyles.body,
            ),
            new InkWell(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Text(
                    flag ? "show more" : "show less",
                    style: new TextStyle(color: Colors.blue),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  flag = !flag;
                });
              },
            ),
          ],
        );
}
