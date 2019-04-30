import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import '../../../blocs/common_link_bloc.dart';

class PrivacyPolicyItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListTile(
        leading: SizedBox.shrink(),
        title: Text(
          'Privacy Policy',
          style: TextStyle(
            color: SarakaColors.lightBlack,
            fontFamily: SarakaFonts.rubik,
          ),
        ),
        onTap: () => Provider.of<CommonLinkBloc>(context).launchPrivacyPolicy(),
      );
}
