import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../models/notification_model.dart' as model;
import '../auth/auth_api.dart';

Future<List<model.Notification>> recupererNotifications() async {
  const String url = '$domaine/api/notifications/';

  try {
    String? token = await getToken();
    if (token == null) {
      throw Exception('Token non trouvé');
    }

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> notificationsJson = data['NotificationsDisponibles'];
      return notificationsJson.map((json) => model.Notification.fromJson(json)).toList();
    } else {
      throw Exception('Échec de la récupération des notifications. Code de statut : ${response.statusCode}');
    }
  } catch (e) {
    print('Exception capturée : $e');
    throw Exception('Échec de la récupération des notifications : $e');
  }
}



Future<void> updateNotificationReadStatus(int notificationId, bool isRead) async {
  final String? token = await getToken();
  if (token == null) {
    throw Exception('Token not found');
  }

  final String url = '$domaine/api/notification/$notificationId/';
  final response = await http.put(
    Uri.parse(url),
    headers: {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'is_read': isRead}),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update notification status: ${response.body}');
  }
}



Future<int> fetchNombreNotificationsNonLues() async {
  final String? token = await getToken();
  if (token == null) {
    throw Exception('Token non trouvé');
  }

  final String url = '$domaine/api/notifications/nombre_non_lues/';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['nombre_non_lues'];
  } else {
    throw Exception('Échec de la récupération du nombre de notifications non lues');
  }
}
