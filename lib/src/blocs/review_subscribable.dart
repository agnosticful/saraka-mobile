import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../entities/authentication_session.dart';
import '../entities/card.dart';
import '../entities/review.dart';
export '../entities/authentication_session.dart';
export '../entities/card.dart';
export '../entities/review.dart';

mixin ReviewSubscribable {
  Observable<List<Review>> subscribeReviewsInCard({
    @required AuthenticationSession session,
    @required Card card,
  });
}
