import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLaunchableText extends StatelessWidget {
  UrlLaunchableText(this.text, {Key key, @required this.url, TextStyle style})
      : assert(text != null),
        assert(url != null),
        style = (style ?? SarakaTextStyles.body)
            .copyWith(decoration: TextDecoration.underline),
        super(key: key);

  final String text;

  final Uri url;

  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Text(text, style: style),
    );
  }

  void _onTap() async {
    final urlString = url.toString();

    if (await canLaunch(urlString)) {
      await launch(urlString);
    } else {
      throw 'Cannot open $urlString';
    }
  }
}
