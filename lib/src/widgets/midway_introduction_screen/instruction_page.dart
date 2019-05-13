import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../blocs/midway_introduction_bloc.dart';

class InstructionPage extends StatelessWidget {
  InstructionPage({
    Key key,
    @required this.color,
    @required this.image,
    @required this.content,
  })  : assert(color != null),
        assert(image != null),
        assert(content != null),
        super(key: key);

  final Color color;

  final Widget image;

  final String content;

  @override
  Widget build(BuildContext context) => Consumer<MidwayIntroductionBloc>(
      builder: (context, midwayIntroductionBloc) => Container(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        image,
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          content,
                          style: SarakaTextStyles.body,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: FlatButton(
                        shape: ContinuousRectangleBorder(
                          side: BorderSide(
                            color: SarakaColors.darkGray,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        onPressed: () {
                          Navigator.of(context).pop();
                          midwayIntroductionBloc.finishMidwayIntroduction();
                        },
                        child: Text(
                          "Tap to Close",
                          style: SarakaTextStyles.buttonLabel
                              .copyWith(color: SarakaColors.darkGray),
                        ),
                      )),
                ],
              ),
            ),
          ));
}
