import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';
import '../arrow.dart';

class Tutorial extends StatefulWidget {
  Tutorial({Key key, @required this.onDismissed}) : super(key: key);

  final VoidCallback onDismissed;

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> with TickerProviderStateMixin {
  AnimationController _animationController;

  Animation _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCirc,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onDismissed();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: FadeTransition(
        opacity: Tween(
          begin: 1.0,
          end: 0.0,
        ).animate(_animation),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 0),
            end: Offset(0, 0.125),
          ).animate(_animation),
          child: ScaleTransition(
            scale: Tween(
              begin: 1.0,
              end: 0.5,
            ).animate(_animation),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: SarakaColors.darkBlack.withOpacity(0.8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 144),
                  LayoutBuilder(
                    builder: (context, constraints) => Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: math.min(constraints.maxWidth * 0.5, 192),
                            padding: EdgeInsets.only(right: 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Swipe to right\nwhen you're sure",
                                  textAlign: TextAlign.right,
                                  style: SarakaTextStyles.body.copyWith(
                                    color: SarakaColors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                SizedBox(
                                  height: 16,
                                  child: Arrow(
                                    color: SarakaColors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ),
                  Expanded(child: Container()),
                  LayoutBuilder(
                    builder: (context, constraints) => Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: math.min(constraints.maxWidth * 0.5, 192),
                            padding: EdgeInsets.only(left: 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 16,
                                  child: Arrow(
                                    color: SarakaColors.white,
                                    strokeWidth: 2,
                                    direction: ArrowDirection.rightToLeft,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Swipe to left\nto study again later",
                                  textAlign: TextAlign.left,
                                  style: SarakaTextStyles.body.copyWith(
                                    color: SarakaColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ),
                  SizedBox(height: 128),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTap() {
    _animationController.forward();
  }
}
