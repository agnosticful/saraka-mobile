import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../entities/card.dart';
import '../entities/review.dart';
import '../entities/user.dart';
export '../entities/card.dart';
export '../entities/review.dart';
export '../entities/user.dart';

mixin ReviewSubscribable {
  Observable<List<Review>> subscribeReviewsInCard({
    @required User user,
    @required Card card,
  });
}
