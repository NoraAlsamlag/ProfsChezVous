// models/message.dart
class Message {
  final int id;
  final int expediteur;
  final int destinataire;
  final String contenu;
  final String? imageUrl;
  final DateTime dateEnvoi;

  Message({
    required this.id,
    required this.expediteur,
    required this.destinataire,
    required this.contenu,
    this.imageUrl,
    required this.dateEnvoi,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      expediteur: json['expediteur'],
      destinataire: json['destinataire'],
      contenu: json['contenu'],
      imageUrl: json['image_url'],
      dateEnvoi: DateTime.parse(json['date_envoi']),
    );
  }
}
