import 'dart:convert' show utf8;
import 'dart:io' show File;
import 'package:crypto/crypto.dart' show sha256;
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import '../blocs/synthesized_sound_file_referable.dart';

class CacheStorage implements SynthesizedSoundFileReferable {
  @override
  Future<File> referSynthesizedSoundFile(String text) async {
    final cacheDirectory = await getTemporaryDirectory();
    final path = join(
      cacheDirectory.path,
      sha256.convert(utf8.encode(text)).toString(),
    );

    return File(path);
  }
}
