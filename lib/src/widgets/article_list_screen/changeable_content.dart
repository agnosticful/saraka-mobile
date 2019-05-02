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
  String firstContent;
  String restContent;

  bool changeContentFlag = true;

  @override
  void initState() {
    super.initState();

    if (widget.content.length > 50) {
      firstContent = widget.content.substring(0, 50);
      restContent = widget.content.substring(50, widget.content.length);
    } else {
      firstContent = widget.content;
      restContent = "";
    }
  }

  @override
  Widget build(BuildContext context) => restContent.isEmpty
      ? Text(
          firstContent,
          style: SarakaTextStyles.body,
        )
      : Column(
          children: <Widget>[
            Text(
              changeContentFlag
                  ? (firstContent + "...")
                  : (firstContent + restContent),
              style: SarakaTextStyles.body,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                InkWell(
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      changeContentFlag ? "See more" : "See less",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      changeContentFlag = !changeContentFlag;
                    });
                  },
                )
              ],
            ),
          ],
        );
}
