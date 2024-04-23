import 'package:profschezvousfrontend/models/user_models.dart';

class Professeur {
  User? user;
  String? ville;
  String? prenom;
  String? nom;
  String? adresse;
  String? quartierResidence;
  String? numeroTelephone;
  String? experienceEnseignement;
  String? certifications;
  double? tarifHoraire;
  DateTime? dateNaissance;
  String? niveauEtude;

  Professeur({
    this.user,
    this.ville,
    this.prenom,
    this.nom,
    this.adresse,
    this.quartierResidence,
    this.numeroTelephone,
    this.experienceEnseignement,
    this.certifications,
    this.tarifHoraire,
    this.dateNaissance,
    this.niveauEtude,
  });

  factory Professeur.fromJson(Map<String, dynamic> json) {
    return Professeur(
      user: User.fromJson(json['user']),
      ville: json['ville'],
      prenom: json['prenom'],
      nom: json['nom'],
      adresse: json['adresse'],
      quartierResidence: json['quartier_résidence'],
      numeroTelephone: json['numero_telephone'],
      experienceEnseignement: json['experience_enseignement'],
      certifications: json['certifications'],
      tarifHoraire: json['tarif_horaire']?.toDouble(),
      dateNaissance: DateTime.parse(json['date_naissance']),
      niveauEtude: json['niveau_etude'],
    );
  }
}