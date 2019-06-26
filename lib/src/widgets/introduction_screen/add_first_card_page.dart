import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import '../../blocs/introduction_bloc.dart';
import '../../entities/card.dart';
import '../card_list_view_item.dart';
import '../disappearable_builder.dart';
import '../new_card_dialog_route.dart';
import '../processable_fancy_button.dart';
import './add_card_button.dart';

class AddFirstCardPage extends StatefulWidget {
  AddFirstCardPage({Key key, @required this.isActive})
      : assert(isActive != null),
        super(key: key);

  final bool isActive;

  @override
  _AddFirstCardPageState createState() => _AddFirstCardPageState();
}

class _AddFirstCardPageState extends State<AddFirstCardPage> {
  bool _isNewCardDialogShown = false;

  @override
  void didUpdateWidget(AddFirstCardPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        Future.delayed(Duration.zero, () async {
          final firstCardListBloc = Provider.of<IntroductionBloc>(context);

          if (!firstCardListBloc
              .hasAlreadyOpenedNewCardDialogAutomatically.value) {
            firstCardListBloc.hasAlreadyOpenedNewCardDialogAutomatically
                .add(true);

            if (!firstCardListBloc.isEnoughCardsAdded.value) {
              setState(() {
                _isNewCardDialogShown = true;
              });

              await showNewCardDialog(context: context);

              setState(() {
                _isNewCardDialogShown = false;
              });
            }
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IntroductionBloc>(
      builder: (context, firstCardListBloc, _) => Container(
            padding: EdgeInsets.fromLTRB(16, 64, 16, 48),
            decoration: BoxDecoration(
              color: SarakaColors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Add first cards",
                  style: SarakaTextStyles.heading.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<Card>>(
                    stream: firstCardListBloc.firstCards,
                    initialData: firstCardListBloc.firstCards.value,
                    builder: (context, cardsSnapshot) => StreamBuilder<bool>(
                          stream: firstCardListBloc.isEnoughCardsAdded,
                          initialData:
                              firstCardListBloc.isEnoughCardsAdded.value,
                          builder: (context, isEnoughCardsAddedSnapshot) =>
                              Align(
                                alignment: cardsSnapshot.requireData.isEmpty
                                    ? Alignment.center
                                    : Alignment.topLeft,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemBuilder: (context, i) => i ==
                                          cardsSnapshot.requireData.length
                                      ? Center(
                                          child: DisappearableBuilder(
                                            isDisappeared:
                                                _isNewCardDialogShown,
                                            child: AddCardButton(
                                              onPressed: () =>
                                                  _onAddCardButtonPressed(
                                                      context),
                                            ),
                                          ),
                                        )
                                      : CardListViewItem(
                                          card: cardsSnapshot.requireData[i],
                                          showDetail: false,
                                        ),
                                  separatorBuilder: (context, _) =>
                                      SizedBox(height: 16),
                                  itemCount: isEnoughCardsAddedSnapshot
                                          .requireData
                                      ? cardsSnapshot.requireData.length
                                      : cardsSnapshot.requireData.length + 1,
                                ),
                              ),
                        ),
                  ),
                ),
                Column(
                  children: [
                    StreamBuilder<bool>(
                      stream: firstCardListBloc.isEnoughCardsAdded,
                      initialData: firstCardListBloc.isEnoughCardsAdded.value,
                      builder: (context, snapshot) => Text(
                            snapshot.requireData
                                ? "You're ready to study!"
                                : "You need more cards to study!",
                            style: SarakaTextStyles.body,
                          ),
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: StreamBuilder<bool>(
                        stream: firstCardListBloc.isEnoughCardsAdded,
                        initialData: firstCardListBloc.isEnoughCardsAdded.value,
                        builder: (context, snapshot) => ProcessableFancyButton(
                              color: SarakaColors.lightRed,
                              isDisabled: !snapshot.requireData,
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamedAndRemoveUntil("/", (_) => false);
                                Navigator.of(context).pushNamed(
                                  '/review',
                                  arguments: {"showTutorial": true},
                                );

                                Future.delayed(Duration(milliseconds: 500), () {
                                  firstCardListBloc.finishIntroduction();
                                });
                              },
                              child: Text("Start Study"),
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  void _onAddCardButtonPressed(BuildContext context) async {
    setState(() {
      _isNewCardDialogShown = true;
    });

    await showNewCardDialog(context: context);

    setState(() {
      _isNewCardDialogShown = false;
    });
  }
}
