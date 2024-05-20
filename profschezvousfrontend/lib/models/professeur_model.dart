import 'package:profschezvousfrontend/models/user_models.dart';

class Professeur extends UserDetails {
  int userId;
  String? ville;
  String? prenom;
  String? nom;
  String? numeroTelephone;
  String? cv;
  String? diplome;
  String? niveauEtude;
  List<dynamic> matieresAEnseigner;
  String? dateNaissance;
  double? latitude;
  double? longitude;

  Professeur({
    
    required this.userId,
    required this.ville,
    required this.prenom,
    required this.nom,
    required this.numeroTelephone,
    required this.cv,
    required this.diplome,
    required this.niveauEtude,
    required this.matieresAEnseigner,
    required this.dateNaissance,
    required this.latitude,
    required this.longitude,
  });

  factory Professeur.fromJson(Map<String, dynamic> json) {
    return Professeur(
      userId: json["user_id"],
      ville: json["ville"],
      prenom: json["prenom"],
      nom: json["nom"],
      numeroTelephone: json["numero_telephone"],
      cv: json["cv"],
      diplome: json["diplome"],
      niveauEtude: json["niveau_etude"],
      matieresAEnseigner: json["matieres_a_enseigner"],
      dateNaissance: json["date_naissance"],
      latitude: json["latitude"],
      longitude: json["longitude"],
    );
  }
}