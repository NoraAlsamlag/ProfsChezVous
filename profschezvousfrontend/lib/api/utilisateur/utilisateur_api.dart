import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../constants.dart';



import 'package:profschezvousfrontend/models/user_models.dart';

class UtilisateurApi {
  static Future<User> fetchUser() async {
    // Effectue une requête HTTP pour récupérer les données de l'utilisateur
    // Remplacez l'URL par l'adresse réelle de votre API
    final response = await http.get(Uri.parse('$domaine/user/obtenir_informations_utilisateur'));

    if (response.statusCode == 200) {
      // Si la requête est réussie, parse le corps de la réponse
      final Map<String, dynamic> data = json.decode(response.body);
      final User user = User.fromJson(data);

      return user;
    } else {
      // Si la requête échoue, lance une exception ou gérez l'erreur en conséquence
      throw Exception('Échec de la récupération des données de l\'utilisateur');
    }
  }
}




Future<String> obtenirAdresseAPartirDesCoordinates(double? latitude, double? longitude) async {
  final url = Uri.parse('$domaine/user/obtenir-adresse/?latitude=$latitude&longitude=$longitude');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['adresse'] as String;
  } else {
    throw Exception('Échec de l\'obtention de l\'adresse');
  }
}






Future<void> uploadProfilePicture(String imagePath,int? user_pk) async {
  var request = http.MultipartRequest('POST', Uri.parse('$domaine/user/ajouter-ou-modifier-photo-profil/$user_pk/'));

  request.files.add(await http.MultipartFile.fromPath('image_profil', imagePath));

  var response = await request.send();

  if (response.statusCode == 200) {
    String jsonResponse = await response.stream.bytesToString();
    // Parse the JSON response if needed
    // Handle the response from the server here
    print(jsonResponse);
  } else {
    String errorResponse = await response.stream.bytesToString();
    // Handle the error response from the server here
    print(errorResponse);
  }
}

void pickAndUploadImage(int? user_pk ) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    String imagePath = pickedFile.path;
    await uploadProfilePicture(imagePath,user_pk);
  }
}