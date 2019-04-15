import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import './dot_indicator.dart';

class IntroductionSlider extends StatefulWidget {
  IntroductionSlider({Key key, @required this.children})
      : assert(children != null),
        super(key: key);

  final List<Widget> children;

  @override
  _IntroductionSliderState createState() => _IntroductionSliderState();
}

class _IntroductionSliderState extends State<IntroductionSlider> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          viewportFraction: 1.0,
          aspectRatio: MediaQuery.of(context).size.aspectRatio,
          enableInfiniteScroll: false,
          onPageChanged: _onPageChanged,
          items: widget.children,
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
      ],
    );
  }

  void _onPageChanged(int i) {
    setState(() {
      _activeIndex = i;
    });
  }
}
