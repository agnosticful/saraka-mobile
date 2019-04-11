import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './cards_maturity_donut_chart.dart';
import 'package:saraka/constants.dart';

class CardsMaturityGridViewItem extends StatelessWidget {

  CardsMaturityGridViewItem(
    {this.totalCardsNumber, this.todayLearnNumber, this.maturedCardNumber}):
    assert(totalCardsNumber != null), assert(todayLearnNumber != null), assert(maturedCardNumber != null);

    final String totalCardsNumber;

    final String todayLearnNumber;

    final List maturedCardNumber;
  
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    elevation: 14.0,
    shadowColor: Color(0x802196F3),
    borderRadius: BorderRadius.circular(10.0),
    child: Column(
      children: <Widget>[
        Container(
          height: 300.0,
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  height: 280.0,
                  width: 280.0,
                  child: CardsMaturityDonutChart.withData(maturedCardNumber),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      totalCardsNumber,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: SarakaColors.lightBlack,
                        fontSize: 30.0,
                        fontFamily: SarakaFonts.rubik,
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(left: 60.0),),
                        Text(
                          'Cards',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: SarakaColors.lightBlack,
                            fontSize: 12.0,
                            fontFamily: SarakaFonts.rubik,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                          ),
                          textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                    Center(
                      child: GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'See card list', 
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: SarakaColors.lightBlack,
                                fontSize: 20.0,
                                fontFamily: SarakaFonts.rubik,
                                fontWeight: FontWeight.w500,
                                height: 1.25,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: SarakaColors.lightBlack,
                            ),
                          ],
                        ),
                        onTap: () => Navigator.of(context).pushNamed('/cards'),
                      ),
                    )
                  ],
                )
              ),
            ],
          ),
        ),
        Container(
          child: Center(
            child: Text(
              todayLearnNumber + ' cards you study for today', 
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: SarakaColors.lightBlack,
                fontSize: 20.0,
                fontFamily: SarakaFonts.rubik,
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    ),
  );
}


