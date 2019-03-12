import 'dart:convert' show base64;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:meta/meta.dart';
import 'package:saraka/blocs.dart';

class FirebaseExternalFunctions implements Synthesizable {
  FirebaseExternalFunctions({
    @required CloudFunctions cloudFunctions,
  })  : assert(cloudFunctions != null),
        _cloudFunctions = cloudFunctions;

  final CloudFunctions _cloudFunctions;

  @override
  Future<List<int>> synthesize(String text) async {
    final audioBase64 = await _cloudFunctions
        .call(functionName: 'synthesize', parameters: {"text": text});

    return base64.decode(audioBase64);
  }
}
