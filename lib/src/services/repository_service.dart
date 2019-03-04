import 'package:meta/meta.dart';
import 'package:saraka/domains.dart';

abstract class RepositoryService {
  Future<void> addNewCard({@required User user, @required String text});
}
