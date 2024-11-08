import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // The URL for the API
  final String url = "https://itqansystem.com/rawda/review-api.php?id=441441326";

  // Fetch the data from the API
  Future<Map<String, dynamic>> fetchStudentData() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load student data');
    }
  }
}
