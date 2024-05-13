import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants.dart';

Future<Map<String, dynamic>> getParent(int userPk) async {
  final String url = '$domaine/user/get_parent/$userPk/';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // La requête a réussi, renvoyez les données du parent
    return Map<String, dynamic>.from(json.decode(response.body));
  } else {
    // La requête a échoué, lancez une exception ou renvoyez un message d'erreur
    throw Exception(
        'Échec de la requête pour récupérer les détails du parent.');
  }
}


Future<void> enregistrerParent({
  required String email,
  required String motDePasse,
  required String nom,
  required String prenom,
  required String dateNaissance,
  required String ville,
  required String numeroTelephone,
  required String latitude,
  required String longitude,
  required List<Map<String, dynamic>> enfants,
}) async {
  // Définir le corps de la requête
  Map<String, dynamic> body = {
    "email": email,
    "password1": motDePasse,
    "password2": motDePasse,
    "nom": nom,
    "prenom": prenom,
    "date_naissance": dateNaissance,
    "ville": ville,
    "numero_telephone": numeroTelephone,
    "latitude": latitude,
    "longitude": longitude,
    "enfants": enfants,
  };

  // Convertir le corps en JSON
  String jsonBody = jsonEncode(body);

  // Envoyer la requête POST
  try {
    final response = await http.post(
      Uri.parse('$domaine/user/register/parent/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonBody,
    );

    // Vérifier si la requête a réussi
    if (response.statusCode == 204) {
      // Pas de contenu à renvoyer (Succès sans contenu)
      print('Parent enregistré avec succès');
    } else if (response.statusCode == 201) {
      // Création réussie (Créé)
      // Vous pouvez également renvoyer le corps de la réponse si nécessaire
      print('Parent enregistré avec succès');
      print('Corps de la réponse : ${response.body}');
    } else {
      // Erreur lors de l'inscription
      print(
          'Erreur lors de l\'enregistrement du parent : ${response.statusCode}');
      print('Réponse du serveur : ${response.body}');
    }
  } catch (error) {
    // Erreur lors de l'envoi de la requête
    print('Erreur lors de la requête : $error');
  }
}
