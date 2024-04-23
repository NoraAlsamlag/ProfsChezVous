import 'dart:convert';
import 'package:http/http.dart' as http;

class ParentAPI {

  
  static Future<Map<String, dynamic>?> getParentInfo(String token) async {
    var url = Uri.parse("http://10.0.2.2:8000/user/parent/info/");
    var response = await http.get(
      url,
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      // Gérer les autres codes d'état HTTP ici si nécessaire
      return null;
    }
    return null;
  }
}
