import 'dart:math' as math;
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/entities.dart';

@immutable
class StackedCard extends StatelessWidget {
  const StackedCard({
    Key key,
    @required Card card,
    @required double swipingRate,
  })  : assert(card != null),
        assert(swipingRate != null),
        assert(swipingRate >= -1),
        assert(swipingRate <= 1),
        _card = card,
        _swipingRate = swipingRate,
        super(key: key);

  final Card _card;

  final double _swipingRate;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          elevation: 4,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.antiAlias,
          color: Color.lerp(
            SarakaColors.white,
            _swipingRate >= 0 ? SarakaColors.lightGreen : SarakaColors.lightRed,
            math.min(_swipingRate.abs() * 1.333, 1),
          ),
          child: InkWell(
            onTap: () => _onTap(context),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  Center(
                    child: Opacity(
                      opacity: _swipingRate.abs(),
                      child: Icon(
                        _swipingRate >= 0
                            ? Feather.getIconData("check")
                            : Feather.getIconData("x"),
                        size: 96,
                        color: SarakaColors.white,
                      ),
                    ),
                  ),
                  Center(
                    child: Opacity(
                      opacity: math.max(1 - _swipingRate.abs() * 2, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Feather.getIconData('volume-2'),
                            color: SarakaColors.darkWhite,
                            size: 96,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Tap to play again",
                            style: SarakaTextStyles.body
                                .copyWith(color: SarakaColors.darkWhite),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onTap(BuildContext context) {
    Provider.of<SynthesizerBloc>(context).play(_card.text);
  }
}
