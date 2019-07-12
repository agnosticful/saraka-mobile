import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/entities.dart';

abstract class ReviewSubscribable {
  Observable<List<Review>> subscribeReviewsInCard({
    @required AuthenticationSession session,
    @required Card card,
  });
}
