import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import '../../blocs/common_link_bloc.dart';
import '../tappable_text.dart';

class PrivacyPolicyItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) => TappableText(
        "Privacy Policy",
        style: SarakaTextStyles.body,
        onTap: () => Provider.of<CommonLinkBloc>(context).launchPrivacyPolicy(),
      );
}
