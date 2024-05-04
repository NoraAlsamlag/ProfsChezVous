import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants.dart';


Future<void> enregistrerProfesseur({
  required String email,
  required String motDePasse,
  required String nom,
  required String prenom,
  required String dateNaissance,
  required String ville,
  required String numeroTelephone,
  required String latitude,
  required String longitude,
  required String experienceEnseignement,
  required String certifications,
  required String matiereAEnseigner,
  required String niveauEtude,
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
    "experience_enseignement": experienceEnseignement,
    "certifications": certifications,
    "longitude": longitude,
    "matiere_a_enseigner": matiereAEnseigner,
    "niveau_etude": niveauEtude,
  };

  // Convertir le corps en JSON
  String jsonBody = jsonEncode(body);

  // Envoyer la requête POST
  try {
    final response = await http.post(
      Uri.parse('$domaine/user/register/professeur/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonBody,
    );

    // Vérifier si la requête a réussi
    if (response.statusCode == 204) {
      // Pas de contenu à renvoyer (Succès sans contenu)
      print('Professeur enregistré avec succès');
    } else if (response.statusCode == 201) {
      // Création réussie (Créé)
      // Vous pouvez également renvoyer le corps de la réponse si nécessaire
      print('Professeur enregistré avec succès');
      print('Corps de la réponse : ${response.body}');
    } else {
      // Erreur lors de l'inscription
      print('Erreur lors de l\'enregistrement du professeur : ${response.statusCode}');
      print('Réponse du serveur : ${response.body}');
    }
  } catch (error) {
    // Erreur lors de l'envoi de la requête
    print('Erreur lors de l\'envoi de la requête : $error');
  }
}