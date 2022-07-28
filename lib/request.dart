import 'package:http/http.dart' as http;
import 'dart:convert';

class resultML {
  final String prediction;

  const resultML({
    required this.prediction,
    });

    factory resultML.fromJson(Map<String, dynamic> json) {
      return resultML(
        prediction: json['prediction'],
      );
    }
}

Future<resultML> createRequest(String values) async {
  final response = await http.post(Uri.parse('http://127.0.0.1:5000/predict'), 
  body: jsonEncode(<String, String>{
    'values': values,
    }),
  );

  if(response.statusCode == 201) {
    return resultML.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load');
  }
}