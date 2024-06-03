// services/message_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:profschezvousfrontend/constants.dart';
import '../../models/message_model.dart';
import '../auth/auth_api.dart';
import 'dart:io';

class MessageApi {
  final String baseUrl = '$domaine/api';
  final storage = FlutterSecureStorage();

  Future<List<Message>> fetchMessages() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token non disponible');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/messages/'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((message) => Message.fromJson(message)).toList();
    } else {
      throw Exception('Échec du chargement des messages');
    }
  }

   Future<void> sendMessage(String contenu, int destinataireId, {String? imageUrl}) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token non disponible');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/messages/envoyer/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'contenu': contenu,
        'destinataire': destinataireId,
        'image_url': imageUrl,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Échec de l\'envoi du message : ${response.body}');
    }
  }


    Future<String> uploadImage(File image) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token non disponible');
    }

    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload_image/'));
    request.headers['Authorization'] = 'Token $token';
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    var response = await request.send();

    if (response.statusCode == 201) {
      var responseData = await response.stream.bytesToString();
      return json.decode(responseData)['image_url'];
    } else {
      throw Exception('Échec du téléchargement de l\'image');
    }
  }

}