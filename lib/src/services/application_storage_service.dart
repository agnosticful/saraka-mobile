import 'dart:convert';
import 'dart:io' show File;
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:saraka/services.dart';

class ApplicationStorageService implements DataPersistentService {
  Future<File> getCachedSynthesizationFile(String text) async {
    final cacheDirectory = await getTemporaryDirectory();
    final path = join(
      cacheDirectory.path,
      sha256.convert(utf8.encode(text)).toString(),
    );

    return File(path);
  }
}
