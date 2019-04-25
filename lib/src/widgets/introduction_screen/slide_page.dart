import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';

class SlidePage extends StatelessWidget {
  SlidePage({
    Key key,
    @required this.headline,
    @required this.description,
    @required this.image,
    @required this.color,
  })  : assert(headline != null),
        assert(description != null),
        assert(image != null),
        assert(color != null),
        super(key: key);

  final String headline;

  final String description;

  final Widget image;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(32, 64, 32, 48),
      decoration: BoxDecoration(color: color),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          image,
          SizedBox(height: 32),
          Text(
            headline,
            style: SarakaTextStyles.heading.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              color: SarakaColors.lightBlack,
            ),
          ),
          SizedBox(height: 16),
          Text(
            description,
            style: SarakaTextStyles.multilineBody
                .copyWith(color: SarakaColors.darkGray),
          ),
        ],
      ),
    );
  }
}
