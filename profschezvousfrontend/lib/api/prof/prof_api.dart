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
  required List<int> matieresAEnseigner,
  required String niveauEtude,
}) async {
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
    "niveau_etude": niveauEtude,
  };

  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$domaine/user/register/professeur/'),
    );

    request.fields.addAll(fields);

    for (var i = 0; i < matieresAEnseigner.length; i++) {
      request.fields['matieres_a_enseigner[$i]'] = matieresAEnseigner[i].toString();
    }

    if (cvPath.isNotEmpty) {
      var cvFile = await http.MultipartFile.fromPath(
        'cv',
        cvPath,
        contentType: MediaType.parse(mimeTypeFromFileExtension(cvPath)),
      );
      request.files.add(cvFile);
    }

    if (diplomePath.isNotEmpty) {
      var diplomeFile = await http.MultipartFile.fromPath(
        'diplome',
        diplomePath,
        contentType: MediaType.parse(mimeTypeFromFileExtension(diplomePath)),
      );
      request.files.add(diplomeFile);
    }

    // print(jsonEncode(request.fields));

    final response = await request.send();

    if (response.statusCode == 204 || response.statusCode == 201) {
      print('Professeur enregistré avec succès');
    } else {
      final responseBody = await response.stream.bytesToString();
      throw Exception(
          'Erreur lors de l\'enregistrement du professeur : ${response.statusCode}\n$responseBody');
    }
  } catch (error) {
    throw Exception('Erreur lors de l\'envoi de la requête : $error');
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

Future<List<dynamic>> obtenirProfesseurs() async {
  final response = await http.get(Uri.parse('$domaine/user/professeurs/'));
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return jsonData['professeursDisponibles'];
  } else {
    throw Exception('Échec de la récupération des professeurs');
  }
}