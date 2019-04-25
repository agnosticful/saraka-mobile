import 'package:flutter/material.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/widgets.dart';
import './dot_indicator.dart';

class IntroductionSlider extends StatefulWidget {
  IntroductionSlider(
      {Key key, this.onActivePageChanged, @required this.children})
      : assert(children != null),
        super(key: key);

  final void Function(int activePageIndex) onActivePageChanged;

  final List<Widget> children;

  @override
  _IntroductionSliderState createState() => _IntroductionSliderState();
}

class _IntroductionSliderState extends State<IntroductionSlider> {
  final controller = PageController();

  int _previousIndex = 0;
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      setState(() {
        _activeIndex = controller.page.round();
      });

      if (_activeIndex != _previousIndex) {
        if (widget.onActivePageChanged != null) {
          widget.onActivePageChanged(_activeIndex);
        }

        _previousIndex = _activeIndex;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: controller,
          children: widget.children,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 16,
              left: 16,
              right: 16,
            ),
            child: DotIndicator(
              length: widget.children.length,
              activeIndex: _activeIndex,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 48,
              left: 16,
              right: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                DisappearableBuilder(
                  isDisappeared: _activeIndex == 0,
                  child: FlatButton(
                    shape: SuperellipseShape(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    onPressed: () => controller.previousPage(
                          curve: Curves.easeInOutCirc,
                          duration: Duration(milliseconds: 300),
                        ),
                    child: Text(
                      "Previous",
                      style: SarakaTextStyles.buttonLabel,
                    ),
                  ),
                ),
                DisappearableBuilder(
                  isDisappeared: _activeIndex == widget.children.length - 1,
                  child: FlatButton(
                    shape: SuperellipseShape(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    onPressed: () => controller.nextPage(
                          curve: Curves.easeInOutCirc,
                          duration: Duration(milliseconds: 300),
                        ),
                    child: Text(
                      "Next",
                      style: SarakaTextStyles.buttonLabel,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
