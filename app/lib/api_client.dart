import 'package:http/http.dart' as http;
import 'dart:convert'; // For decoding JSON

class Apiclient {
  final String baseUrl = "https://api.github.com/";

  Future<dynamic> get(String endpoint) async {
    final Uri uri = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null; // Or throw an error
      }
    } catch (e) {
      print('Error during GET request: $e');
      return null; // Or throw an error
    }
  }
}