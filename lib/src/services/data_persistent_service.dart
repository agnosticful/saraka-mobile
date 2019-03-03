import 'dart:io';

abstract class DataPersistentService {
  Future<File> getReference(String key);
}
