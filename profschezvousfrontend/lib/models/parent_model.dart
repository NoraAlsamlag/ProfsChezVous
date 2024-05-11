import 'package:profschezvousfrontend/models/user_models.dart';

class Parent extends UserDetails {
  int userId;
  String? ville;
  String? prenom;
  String? nom;
  String? dateNaissance;
  String? numeroTelephone;
  double latitude;
  double longitude;

  Parent({
    required this.userId,
    required this.ville,
    required this.prenom,
    required this.nom,
    required this.dateNaissance,
    required this.numeroTelephone,
    required this.latitude,
    required this.longitude,
  });
  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      userId: json["user_id"],
      ville: json["ville"],
      prenom: json["prenom"],
      nom: json["nom"],
      dateNaissance: json["date_naissance"],
      numeroTelephone: json["numero_telephone"],
      latitude: json["latitude"],
      longitude: json["longitude"],
    );
  }
}