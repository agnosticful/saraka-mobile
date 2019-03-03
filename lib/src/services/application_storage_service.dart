import 'dart:io' show File;
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:saraka/services.dart';
import 'package:uuid/uuid.dart';

class ApplicationStorageService implements DataPersistentService {
  Future<File> getReference(String key) async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    final filename = Uuid().v5(Uuid.NAMESPACE_NIL, key);
    final path = join(documentDirectory.path, '$filename');

    return File(path);
  }
}
