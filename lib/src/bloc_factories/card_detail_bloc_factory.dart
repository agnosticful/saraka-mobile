import 'dart:async';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../blocs/card_detail_bloc.dart';
import '../entities/authentication_session.dart';
import './common_interfaces/text_speechable.dart';

export '../entities/authentication_session.dart';
export '../entities/card.dart';
export '../entities/review.dart';
export './common_interfaces/text_speechable.dart';

class CardDetailBlocFactory {
  CardDetailBlocFactory({
    @required CardReviewListable cardReviewListable,
    @required TextSpeechable textSpeechable,
  })  : assert(cardReviewListable != null),
        assert(textSpeechable != null),
        _cardReviewListable = cardReviewListable,
        _textSpeechable = textSpeechable;

  final CardReviewListable _cardReviewListable;

  final TextSpeechable _textSpeechable;

  CardDetailBloc create({
    @required AuthenticationSession session,
    @required Card card,
  }) =>
      _CardDetailBloc(
        cardReviewListable: _cardReviewListable,
        textSpeechable: _textSpeechable,
        session: session,
        card: card,
      );
}

abstract class CardReviewListable {
  Observable<List<Review>> subscribeReviewsOfCard({
    @required AuthenticationSession session,
    @required Card card,
  });
}

class _CardDetailBloc implements CardDetailBloc {
  _CardDetailBloc({
    @required this.cardReviewListable,
    @required this.textSpeechable,
    @required this.session,
    @required this.card,
  })  : assert(cardReviewListable != null),
        assert(textSpeechable != null),
        assert(session != null),
        assert(card != null),
        reviews = ValueConnectableObservable(
          cardReviewListable.subscribeReviewsOfCard(
            session: session,
            card: card,
          ),
        );

  final CardReviewListable cardReviewListable;

  final TextSpeechable textSpeechable;

  final AuthenticationSession session;

  StreamSubscription _reviewsSubscription;

  @override
  final Card card;

  @override
  final ValueConnectableObservable<List<Review>> reviews;

  @override
  final BehaviorSubject<bool> isSpeechSoundLoaded =
      BehaviorSubject.seeded(false);

  @override
  void speech() {
    textSpeechable.speech(card.text);
  }

  @override
  void initialize() async {
    _reviewsSubscription = reviews.connect();

    if (!await textSpeechable.isPreloaded(card.text)) {
      await textSpeechable.preload(card.text);
    }

    isSpeechSoundLoaded.add(true);
  }

  @override
  void dispose() {
    _reviewsSubscription?.cancel();
    isSpeechSoundLoaded.close();
  }
}
