import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/entities.dart' show Card, Review, User;
export 'package:saraka/entities.dart' show Card, Review, User;

mixin ReviewSubscribable {
  Observable<List<Review>> subscribeReviewsInCard({
    @required User user,
    @required Card card,
  });
}
