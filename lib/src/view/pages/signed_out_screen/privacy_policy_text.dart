import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/widgets.dart';

class PrivacyPolicyItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) => TappableText(
        "Privacy Policy",
        style: SarakaTextStyle.body,
        onTap: () => Provider.of<CommonLinkBloc>(context).launchPrivacyPolicy(),
      );
}
