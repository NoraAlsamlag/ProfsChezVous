import 'package:flutter/material.dart';
import '../../models/notification_model.dart';


class NotificationEcrant extends StatefulWidget {
  @override
  _NotificationEcrantState createState() => _NotificationEcrantState();
}

class _NotificationEcrantState extends State<NotificationEcrant> {
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    loadNotifications(); // Simulate loading data
  }

  void loadNotifications() {
    // Simulated data loading
    setState(() {
      notifications = [
        NotificationModel(
          title: "Welcome",
          message: "Thanks for joining our service!",
          date: DateTime.now(),
        ),
        NotificationModel(
          title: "Reminder",
          message: "Don't forget your weekly check-in!",
          date: DateTime.now().subtract(Duration(days: 1)),
        ),
        // Add more notifications as needed
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          NotificationModel notification = notifications[index];
          return ListTile(
            title: Text(notification.title),
            subtitle: Text(notification.message),
            trailing: Text(
              "${notification.date.day}/${notification.date.month}/${notification.date.year}",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          );
        },
      ),
    );
  }
}




