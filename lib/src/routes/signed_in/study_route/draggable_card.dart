import 'dart:math' show pi;
import 'package:flutter/material.dart' show InkWell, Material;
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/domains.dart';
import 'package:saraka/usecases.dart';

const _VERTICAL_PADDING = 16.0;
const _HORIZONTAL_PADDING = 16.0;

class DraggableCard extends StatefulWidget {
  DraggableCard({
    Key key,
    @required this.card,
    this.cardsInFront = 0,
  })  : assert(card != null),
        super(key: key);

  final Card card;

  final int cardsInFront;

  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with TickerProviderStateMixin {
  Offset cardOffset = const Offset(0, 0);
  Offset dragStart;
  Offset dragPosition;
  Offset dragBackStart;
  Offset slideBackStart;
  AnimationController slideBackAnimation;
  Tween<Offset> slideOutTween;
  AnimationController slideOutAnimation;
  TextSynthesization _textSynthesization;

  @override
  void initState() {
    super.initState();

    slideBackAnimation = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this)
      ..addListener(() => setState(() {
            cardOffset = Offset.lerp(
              slideBackStart,
              const Offset(0, 0),
              Curves.easeInOut.transform(slideBackAnimation.value),
            );
          }))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            slideBackStart = null;
            dragPosition = null;
          });
        }
      });

    slideOutAnimation = new AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          cardOffset = slideOutTween.evaluate(slideOutAnimation);
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (cardOffset.dx < 0) {
            widget.card.markLearned(LearningCertainty.vague);
          } else {
            widget.card.markLearned(LearningCertainty.good);
          }
        }
      });

    Future.delayed(Duration.zero, () async {
      final textSynthesization = await Provider.of<TextSynthesizationUsecase>(
          context)(widget.card.text);

      setState(() {
        _textSynthesization = textSynthesization;
      });

      if (widget.cardsInFront == 0) {
        _textSynthesization.onReadyToPlay.then((_) {
          print(_textSynthesization.isReadyToPlay);

          _textSynthesization.play();
        });
      }
    });
  }

  @override
  void didUpdateWidget(DraggableCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.cardsInFront == 0) {
      _textSynthesization.onReadyToPlay.then((_) {
        print(_textSynthesization.isReadyToPlay);

        _textSynthesization.play();
      });
    }
  }

  @override
  void dispose() {
    slideBackAnimation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final rect = Rect.fromLTRB(
      mediaQuery.padding.left + _HORIZONTAL_PADDING + widget.cardsInFront * 4,
      mediaQuery.padding.top + _VERTICAL_PADDING + 88 - widget.cardsInFront * 4,
      mediaQuery.size.width - (_HORIZONTAL_PADDING + widget.cardsInFront * 4),
      mediaQuery.size.height -
          (_VERTICAL_PADDING + 64 + widget.cardsInFront * 4),
    );

    final cardContent = Container(
      width: rect.width,
      height: rect.height,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Icon(
          Feather.getIconData('volume-2'),
          color: SarakaColors.darkWhite,
          size: 96,
        ),
      ),
    );

    return Positioned.fromRect(
      rect: rect,
      child: Transform(
        transform: Matrix4.translationValues(cardOffset.dx, cardOffset.dy, 0)
          ..rotateZ(_rotation(rect)),
        origin: _rotationOrigin(rect),
        child: Material(
          elevation: 4,
          shape: SuperellipseShape(borderRadius: BorderRadius.circular(24)),
          clipBehavior: Clip.antiAlias,
          color: SarakaColors.white,
          child: widget.cardsInFront == 0
              ? GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanStart: _onPanStart,
                  onPanEnd: _onPanEnd,
                  onPanUpdate: _onPanUpdate,
                  child: InkWell(
                    onTap: _textSynthesization != null &&
                            _textSynthesization.isReadyToPlay
                        ? _onTap
                        : null,
                    child: cardContent,
                  ),
                )
              : cardContent,
        ),
      ),
    );
  }

  double _rotation(Rect dragBounds) {
    if (dragStart != null) {
      return pi / 8 * 1 * cardOffset.dx / dragBounds.width;
    } else {
      return 0;
    }
  }

  Offset _rotationOrigin(Rect dragBounds) {
    if (dragStart != null) {
      return dragStart - dragBounds.topLeft;
    } else {
      return const Offset(0, 0);
    }
  }

  void _onPanStart(DragStartDetails details) {
    dragStart = details.globalPosition;

    if (slideBackAnimation.isAnimating) {
      slideBackAnimation.stop(canceled: true);
    }
  }

  void _onPanEnd(DragEndDetails details) {
    final dragVector = cardOffset / cardOffset.distance;
    final isInLeft = cardOffset.dx / context.size.width < -0.5;
    final isInRight = cardOffset.dx / context.size.width > 0.5;

    setState(() {
      if (isInLeft || isInRight) {
        slideOutTween =
            Tween(begin: cardOffset, end: dragVector * 2 * context.size.width);
        slideOutAnimation.forward(from: 0);
      } else {
        slideBackStart = cardOffset;
        slideBackAnimation.forward(from: 0);
      }
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      dragPosition = details.globalPosition;
      cardOffset = dragPosition - dragStart;
    });
  }

  void _onTap() {
    assert(_textSynthesization != null);
    assert(_textSynthesization.isReadyToPlay);

    _textSynthesization.play();
  }
}
