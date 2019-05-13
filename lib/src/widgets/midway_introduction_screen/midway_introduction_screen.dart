import 'package:flutter/material.dart';
import 'package:saraka/src/blocs/authentication_bloc.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../fancy_popup_dialog.dart';
import './instruction_page.dart';

Future<void> showMidwayIntroductionDialog({
  @required context,
}) {
  assert(context != null);

  final authenticationBloc = Provider.of<AuthenticationBloc>(context);

  if (authenticationBloc.user.value.isIntroductionFinished) {
    return null;
  }

  String image;
  String content;
  String introName = "";

  switch (introName) {
    case "phraseIntro":
      image = "assets/images/introduction2.png";
      content =
          "Parrot learn the progress of your fluency from your swipe and reflect the review interval";
      break;

    case "test2":
      image = "assets/images/introduction2.png";
      content =
          "Parrot recomment you to add not only word but also phrases. Parrot use AI for speaking natively. Let's add [Can I please order a double double.].";
      break;

    case "test3":
      image = "assets/images/introduction2.png";
      content =
          "You will study phrases using psychological study unconciously. Parrot provide you to review best timing for you.";
      break;

    case "test4":
      image = "assets/images/introduction2.png";
      content = "";
      break;

    case "test5":
      image = "assets/images/introduction2.png";
      content = "";
      break;

    default:
      image = "assets/images/parrot.png";
      content = "Opps, something is going wrong.";
  }

  return showFancyPopupDialog(
    context: context,
    pageBuilder: (context, _, __) => MidwayIntroductionScreen(
          image: image,
          content: content,
        ),
  );
}

class MidwayIntroductionScreen extends StatelessWidget {
  MidwayIntroductionScreen({@required String image, @required String content})
      : assert(image != null),
        assert(content != null),
        _image = image,
        _content = content;

  final String _image;

  final String _content;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 25,
          horizontal: 15,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: SarakaColors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: InstructionPage(
            color: SarakaColors.white,
            image: Image.asset(_image),
            content: _content,
          ),
        ),
      ),
    );
  }
}
