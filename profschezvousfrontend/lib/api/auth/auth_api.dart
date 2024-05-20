import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as path_provider;
import '../../constants.dart';
import '../../models/user_models.dart';

const String tokenBox = 'tokenBox';

Future<String?> getToken() async {
  var box = await Hive.openBox(tokenBox);
  return box.get('token');
}

Future<dynamic> authentificationUtilisateur(String? email, String? password) async {
  Map<String, String> body = {
    "email": email!,
    "password": password!,
  };

  var url = Uri.parse("$domaine/user/auth/login/");
  var res = await http.post(url, body: body);

  print(res.body);
  print(res.statusCode);

  if (res.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(res.body);
    String token = json['key'];
    var box = await Hive.openBox(tokenBox);
    await box.put("token", token);
    User? user = await getUser(token);
    return user;
  } else {
    Map<String, dynamic> json = jsonDecode(res.body);
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
  var url = Uri.parse("$domaine/user/auth/user/");
  var res = await http.get(url, headers: {
    'Authorization': 'Token $token',
  });

  if (res.statusCode == 200) {
    var json = jsonDecode(utf8.decode(res.bodyBytes));
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
    Map<String, dynamic> donneesUtilisateur = jsonDecode(response.body);
    return donneesUtilisateur;
  } else {
    throw Exception('Échec du chargement des informations utilisateur');
  }
}
