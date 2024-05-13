import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:profschezvousfrontend/models/user_models.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../../constants.dart';

Future<String?> getTokenFromHive() async {
  final tokenBox = await Hive.openBox('tokenBox');
  String? token = tokenBox.get('token');
  return token;
}

Future<dynamic> authentificationUtilisateur(String? email, String? password) async {

// Initialize Hive
  await Hive.initFlutter();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Map body = {
    "email": email,
    "password": password
  };
  var url = Uri.parse("$domaine/user/auth/login/");
  var res = await http.post(url, body: body);

  print(res.body);
  print(res.statusCode);
  if (res.statusCode == 200) {
    Map json = jsonDecode(res.body);
    String token = json['key'];
    var box = await Hive.openBox(tokenBox);
    box.put("token", token);
    User? user = await getUser(token);
    return user;
  } else {
    Map json = jsonDecode(res.body);
    print(json);
    if (json.containsKey("email")) {
      return json["email"][0];
    }
    if (json.containsKey("password")) {
      return json["password"][0];
    }
    if (json.containsKey("non_field_errors")) {
      return json["non_field_errors"][0];
    }
  }
}

Future<User?> getUser(String token) async {
  var url = Uri.parse("$domaine/user/auth/user");
  var res = await http.get(url, headers: {
    'Authorization': 'Token ${token}',
  });

  if (res.statusCode == 200) {
    var jsonString = res.body;
    var json = jsonDecode(utf8.decode(jsonString.runes.toList()));

    User user = User.fromJson(json);
    user.token = token;
    return user;
  } else {
    return null;
  }
}



Future<void> deconnexion(String token) async {
  var url = Uri.parse("$domaine/user/auth/logout/");
  var response = await http.post(
    url,
    headers: {
      'Authorization': 'Token $token',
    },
  );

  if (response.statusCode == 200) {
    var box = await Hive.openBox(tokenBox);
    await box.delete("token");
  } else {
    print('Failed to deconnexion: ${response.statusCode}');
  }
}


Future<Map<String, dynamic>> getUserInfo(int? userPk) async {
  var url = Uri.parse('$domaine/user/get_user_info/$userPk/');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    // Convertir le corps de la réponse en une map
    Map<String, dynamic> donneesUtilisateur = jsonDecode(response.body);
    return donneesUtilisateur;
  } else {
    // Gérer l'erreur
    throw Exception('Échec du chargement des informations utilisateur');
  }
}





// example1gmail.com
// 1GpTuZ6E