import 'package:profschezvousfrontend/models/user_models.dart';

class Parent {
  User? user;
  String? ville;
  String? adresse;
  String? prenom;
  String? nom;
  DateTime? dateNaissance;
  String? numeroTelephone;
  String? quartierResidence;

  Parent({
    this.user,
    this.ville,
    this.adresse,
    this.prenom,
    this.nom,
    this.dateNaissance,
    this.numeroTelephone,
    this.quartierResidence,
  });

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      user: User.fromJson(json['user']),
      ville: json['ville'],
      adresse: json['adresse'],
      prenom: json['prenom'],
      nom: json['nom'],
      dateNaissance: DateTime.parse(json['date_naissance']),
      numeroTelephone: json['numero_telephone'],
      quartierResidence: json['quartier_résidence'],
    );
  }
}