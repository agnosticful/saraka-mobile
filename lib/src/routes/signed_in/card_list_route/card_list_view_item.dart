import 'package:flutter/material.dart' show IconButton, InkWell, Material;
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';
import './maturity_line_chart.dart';
import './next_study_date_text.dart';
import './synthesize_icon_button.dart';

class CardListViewItem extends StatefulWidget {
  CardListViewItem({
    Key key,
    @required this.card,
    @required this.onTap,
    this.isExpanded,
  })  : assert(card != null),
        assert(onTap != null),
        assert(isExpanded != null),
        super(key: key);

  final Card card;

  final VoidCallback onTap;

  final bool isExpanded;

  @override
  State<CardListViewItem> createState() => _CardListViewItemState();
}

class _CardListViewItemState extends State<CardListViewItem>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: widget.isExpanded ? 1 : 0,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void didUpdateWidget(CardListViewItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) => Material(
        shape: SuperellipseShape(borderRadius: BorderRadius.circular(24)),
        elevation: 6,
        shadowColor: SarakaColors.darkGray.withOpacity(0.25),
        clipBehavior: Clip.antiAlias,
        color: Color(0xffffffff),
        child: InkWell(
          onTap: widget.onTap,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Positioned.fill(
                child: FadeTransition(
                  opacity: _animation,
                  child: Container(
                    padding: EdgeInsets.only(top: 16, right: 64, bottom: 16),
                    child: MaturityLineChart(),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(bottom: 4, left: 4, right: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.card.text,
                              overflow: widget.isExpanded
                                  ? null
                                  : TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: SarakaColors.lightBlack,
                                fontSize: 16,
                                fontFamily: SarakaFonts.rubik,
                                fontWeight: FontWeight.w500,
                                height: 1.25,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(width: 8),
                          RotationTransition(
                            turns:
                                Tween(begin: 0.0, end: 0.5).animate(_animation),
                            child: Icon(
                              Feather.getIconData('chevron-down'),
                              color: SarakaColors.lightGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizeTransition(
                      sizeFactor: _animation,
                      child: FadeTransition(
                        opacity: _animation,
                        child: Container(
                          padding: const EdgeInsets.only(top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SynthesizeIconButton(text: widget.card.text),
                              Container(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Next Study",
                                      style: const TextStyle(
                                        color: SarakaColors.darkGray,
                                        fontFamily: SarakaFonts.rubik,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    NextStudyDateText(card: widget.card),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Feather.getIconData('trash-2')),
                                color: SarakaColors.darkGray,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
