import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:saraka/constants.dart';

class AppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  material.Size get preferredSize => Size.fromHeight(material.kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return material.AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/parrot-portrait.png',
            height: 24,
          ),
          SizedBox(width: 4),
          Text(
            'Parrot',
            style: SarakaTextStyles.appBarTitle.copyWith(
              color: SarakaColors.lightBlack,
            ),
          ),
        ],
      ),
      centerTitle: true,
      backgroundColor: Color(0x00000000),
      elevation: 0,
      iconTheme: IconThemeData(color: SarakaColors.lightBlack),
    );
  }
}
