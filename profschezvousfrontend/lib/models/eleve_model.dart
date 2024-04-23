import 'package:profschezvousfrontend/models/user_models.dart';

class Eleve {
  User? user;
  String? ville;
  String? adresse;
  String? prenom;
  String? nom;
  DateTime? dateNaissance;
  String? etablissement;
  String? niveauScolaire;
  String? genre;
  String? numeroTelephone;

  Eleve({
    this.user,
    this.ville,
    this.adresse,
    this.prenom,
    this.nom,
    this.dateNaissance,
    this.etablissement,
    this.niveauScolaire,
    this.genre,
    this.numeroTelephone,
  });

  factory Eleve.fromJson(Map<String, dynamic> json) {
    return Eleve(
      user: User.fromJson(json['user']),
      ville: json['ville'],
      adresse: json['adresse'],
      prenom: json['prenom'],
      nom: json['nom'],
      dateNaissance: DateTime.parse(json['date_naissance']),
      etablissement: json['Etablissement'],
      niveauScolaire: json['niveau_scolaire'],
      genre: json['genre'],
      numeroTelephone: json['numero_telephone'],
    );
  }
}