import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';

class PrivacyPolicyItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListTile(
        leading: SizedBox.shrink(),
        title: Text(
          'Privacy Policy',
          style: SarakaTextStyle.body,
        ),
        onTap: () => Provider.of<CommonLinkBloc>(context).launchPrivacyPolicy(),
      );
}
