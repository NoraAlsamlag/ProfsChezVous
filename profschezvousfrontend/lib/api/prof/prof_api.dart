import 'dart:convert';
import '../../constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

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
  required String diplomePath,
  required String cvPath,
  required String matiereAEnseigner,
  required String niveauEtude,
}) async {
  // Définir le corps de la requête
  Map<String, String> fields = {
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
    "matiere_a_enseigner": matiereAEnseigner,
    "niveau_etude": niveauEtude,
  };

  // Envoyer la requête POST avec les pièces jointes
  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$domaine/user/register/professeur/'),
    );

    // Ajouter les champs à la requête
    request.fields.addAll(fields);

    // Ajouter le fichier CV à la requête
    var cvFile = await http.MultipartFile.fromPath(
      'cv',
      cvPath,
      contentType: MediaType.parse(mimeTypeFromFileExtension(cvPath)),
    );
    request.files.add(cvFile);

    // Ajouter le fichier diplôme à la requête
    var diplomeFile = await http.MultipartFile.fromPath(
      'diplome',
      diplomePath,
      contentType: MediaType.parse(mimeTypeFromFileExtension(diplomePath)),
    );
    request.files.add(diplomeFile);

    // Envoyer la requête
    final response = await request.send();

    // Vérifier si la requête a réussi
    if (response.statusCode == 204) {
      // Pas de contenu à retourner (succès sans contenu)
      print('Professeur enregistré avec succès');
    } else if (response.statusCode == 201) {
      // Création réussie (créé)
      // Vous pouvez également lire le corps de la réponse si nécessaire
      print('Professeur enregistré avec succès');
    } else {
      // Erreur lors de l'enregistrement
      print('Erreur lors de l\'enregistrement du professeur : ${response.statusCode}');
      print('Réponse du serveur : ${await response.stream.bytesToString()}');
    }
  } catch (error) {
    // Erreur lors de l'envoi de la requête
    print('Erreur lors de l\'envoi de la requête : $error');
  }
}

String mimeTypeFromFileExtension(String filePath) {
  final ext = extension(filePath).toLowerCase();
  switch (ext) {
    case '.pdf':
      return 'application/pdf';
    case '.doc':
      return 'application/msword';
    case '.docx':
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    case '.jpeg':
    case '.jpg':
      return 'image/jpeg';
    case '.png':
      return 'image/png';
    default:
      throw UnsupportedError('Extension de fichier non prise en charge : $ext');
  }
}