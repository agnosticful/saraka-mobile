import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';

class TappableText extends StatelessWidget {
  TappableText(this.text, {Key key, @required this.onTap, TextStyle style})
      : assert(text != null),
        assert(onTap != null),
        style = (style ?? SarakaTextStyle.body)
            .copyWith(decoration: TextDecoration.underline),
        super(key: key);

  final String text;

  final VoidCallback onTap;

  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(text, style: style),
    );
  }
}
