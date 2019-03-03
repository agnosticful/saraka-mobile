import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'package:saraka/services.dart';

class FirebaseFunctionService implements ExternalFunctionService {
  Future<List<int>> getSynthesizedAudio(String text) async {
    final response = await http.post(
      new Uri.https(
        'us-central1-whitfield-io.cloudfunctions.net',
        '/synthesize',
      ),
      headers: {"content-type": "application/json"},
      body: json.encode({
        "data": {
          "text": text,
        },
      }),
    );

    return UriData.parse(json.decode(response.body)['result']).contentAsBytes();
  }
}
