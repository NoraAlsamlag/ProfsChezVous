import 'package:flutter/material.dart';
import 'package:profschezvousfrontend/models/notification_model.dart' as model;
import '../../api/notification/notification_api.dart';
import 'composent/notification_detail.dart';

class NotificationEcrant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: FutureBuilder<List<model.Notification>>(
        future: recupererNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<model.Notification> notifications = snapshot.data!;
            // Sort the notifications by date in descending order
            notifications.sort((a, b) => b.date.compareTo(a.date));

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(
                      notif.isRead ? Icons.mark_email_read : Icons.email,
                      color: notif.isRead ? Colors.green : Colors.red,
                    ),
                    title: Text(
                      notif.title,
                      style: TextStyle(
                        fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notif.message),
                        const SizedBox(height: 4),
                        Text(
                          getTimeElapsed(notif.date),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationDetailPage(notification: notif),
                        ),
                      ).then((_) {
                        // Refresh the state after returning from the detail page
                        (context as Element).reassemble();
                      });
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Aucune notification trouvée.'));
          }
        },
      ),
    );
  }

  String getTimeElapsed(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 1) {
      return 'il y a ${difference.inDays} jours';
    } else if (difference.inDays == 1) {
      return 'il y a 1 jour';
    } else if (difference.inHours > 1) {
      return 'il y a ${difference.inHours} heures';
    } else if (difference.inHours == 1) {
      return 'il y a 1 heure';
    } else if (difference.inMinutes > 1) {
      return 'il y a ${difference.inMinutes} minutes';
    } else if (difference.inMinutes == 1) {
      return 'il y a 1 minute';
    } else {
      return 'à l\'instant';
    }
  }
}
