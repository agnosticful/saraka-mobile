import 'dart:io';

abstract class DataPersistentService {
  Future<File> getCachedSynthesizationFile(String text);
}
