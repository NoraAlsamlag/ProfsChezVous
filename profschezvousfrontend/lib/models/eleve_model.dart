import 'package:profschezvousfrontend/models/user_models.dart';

class Eleve extends UserDetails {
  int userId;
  String ville;
  String prenom;
  String nom;
  String dateNaissance;
  String etablissement;
  String niveauScolaire;
  String numeroTelephone;
  double latitude;
  double longitude;

  Eleve({
    required this.userId,
    required this.ville,
    required this.prenom,
    required this.nom,
    required this.dateNaissance,
    required this.etablissement,
    required this.niveauScolaire,
    required this.numeroTelephone,
    required this.latitude,
    required this.longitude,
  });

  factory Eleve.fromJson(Map<String, dynamic> json) {
    return Eleve(
      userId: json["user_id"],
      ville: json["ville"],
      prenom: json["prenom"],
      nom: json["nom"],
      dateNaissance: json["date_naissance"],
      etablissement: json["etablissement"],
      niveauScolaire: json["niveau_scolaire"],
      numeroTelephone: json["numero_telephone"],
      latitude: json["latitude"],
      longitude: json["longitude"],
    );
  }
}
