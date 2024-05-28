
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:profschezvousfrontend/constants.dart';
import '../../models/cour_model.dart';
import '../auth/auth_api.dart';


class CourApi {
  final String baseUrl = '$domaine/api';
  final storage = FlutterSecureStorage();



  Future<List<Cour>> fetchCours(String endpoint) async {
  final token = await getToken();
  final response = await http.get(
    Uri.parse('$baseUrl/$endpoint'),
    headers: {'Authorization': 'Token $token'},
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
    return jsonResponse.map((cour) => Cour.fromJson(cour)).toList();
  } else {
    throw Exception("Échec du chargement des cours");
  }
}

 Future<http.Response> mettreAJourPresence(int coursId, bool present) async {
    String? token = await getToken();
    final response = await http.patch(
      Uri.parse('$domaine/api/mettre-a-jour-presence/$coursId/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'present': present}),
    );
    return response;
  }

 Future<http.Response> mettreAJourStatut(int coursId, String statut) async {
    String? token = await getToken();
    final response = await http.patch(
      Uri.parse('$domaine/api/mettre-a-jour-statut/$coursId/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'statut': statut}),
    );
    return response;
  }

  Future<http.Response> mettreAJourDispense(int coursId, bool dispense) async {
    String? token = await getToken();
    final response = await http.patch(
      Uri.parse('$domaine/api/mettre-a-jour-dispense/$coursId/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'dispense': dispense}),
    );
    return response;
  }

Future<void> ajouterCommentaire(int coursId, String commentaire, String? token) async {
  final response = await http.post(
    Uri.parse('$domaine/api/ajouter-commentaire/'),
    headers: {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'cour': coursId,
      'contenu': commentaire,
    }),
  );

  if (response.statusCode == 201) {
    return;
  } else if (response.statusCode == 400) {
    throw Exception(jsonDecode(response.body)['detail']);
  } else {
    throw Exception('Erreur lors de l\'ajout du commentaire.');
  }
}


}
