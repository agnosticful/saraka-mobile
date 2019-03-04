import 'dart:convert' show base64;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:meta/meta.dart';
import 'package:saraka/services.dart';

class FirebaseFunctionService implements ExternalFunctionService {
  FirebaseFunctionService({@required CloudFunctions functions})
      : assert(functions != null),
        _functions = functions;

  final CloudFunctions _functions;

  Future<List<int>> synthesize(String text) async {
    final audioBase64 = await _functions
        .call(functionName: 'synthesize', parameters: {"text": text});
    final audio = base64.decode(audioBase64);

    return audio;
  }
}
