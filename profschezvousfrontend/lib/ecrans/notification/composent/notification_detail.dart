import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:profschezvousfrontend/models/notification_model.dart' as model;
import '../../../api/auth/auth_api.dart';
import '../../../api/notification/notification_api.dart';
import '../../../components/format_date.dart';

class NotificationDetailPage extends StatelessWidget {
  final model.Notification notification;

  NotificationDetailPage({required this.notification});

  Future<void> markAsRead() async {
    // Appeler l'API pour marquer la notification comme lue
    await updateNotificationReadStatus(notification.id, true);
  }

    Future<void> _launchUrlWithToken(Uri url, BuildContext context) async {
    final token = await getToken();  // Assume you have a method to get the token
    if (token != null) {
      final Uri urlWithToken = url.replace(queryParameters: {
        ...url.queryParameters,
        'token': token,
      });
      if (!await launchUrl(urlWithToken, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Impossible d\'ouvrir le lien $urlWithToken'),
          ),
        );
        throw Exception('Could not launch $urlWithToken');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Token non trouvé'),
        ),
      );
    }
  }
  String extractUrl(String message) {
    final urlRegex = RegExp(
      r'(https?:\/\/[^\s]+)',
      caseSensitive: false,
    );
    final match = urlRegex.firstMatch(message);
    return match != null ? match.group(0) ?? '' : '';
  }

  @override
  Widget build(BuildContext context) {
    // Marquer la notification comme lue lorsque cette page est ouverte
    if (!notification.isRead) {
      markAsRead().then((_) {
        notification.isRead = true;
      });
    }

    final String link = extractUrl(notification.message); // Extraire l'URL du message de notification
    final String messageWithoutLink = notification.message.replaceAll(link, ''); // Supprimer l'URL du message

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la Notification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              messageWithoutLink,
              style: const TextStyle(fontSize: 16),
            ),
            if (link.isNotEmpty)
              Column(
                children: [
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      try {
                        final Uri url = Uri.parse(link);
                        await _launchUrlWithToken(url, context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Erreur lors de l\'ouverture du lien: $e',
                            ),
                          ),
                        );
                        print('Erreur lors de l\'ouverture du lien: $e');
                      }
                    },
                    child: Text(
                      link,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Text(
              'Date: ${formatDate(notification.date)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
