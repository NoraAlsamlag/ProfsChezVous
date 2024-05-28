import 'package:flutter/material.dart';
import 'package:profschezvousfrontend/models/notification_model.dart' as model;

import '../../../api/notification/notification_api.dart';
import '../../../components/format_date.dart';

class NotificationDetailPage extends StatelessWidget {
  final model.Notification notification;

  NotificationDetailPage({required this.notification});

  Future<void> markAsRead() async {
    // Call the API to mark the notification as read
    await updateNotificationReadStatus(notification.id, true);
  }

  @override
  Widget build(BuildContext context) {
    // Mark the notification as read when this page is opened
    if (!notification.isRead) {
      markAsRead().then((_) {
        notification.isRead = true;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la Notification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              notification.message,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Date: ${formatDate(notification.date)}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
