class Cour {
  final int id;
  final String professeurNomComplet;
  final String date;
  final String heureDebut;
  final String heureFin;
  final bool present;
  final bool dispense;
  final String statut;
  final String? commentaire;
  final String? commentaireUser;

  Cour({
    required this.id,
    required this.professeurNomComplet,
    required this.date,
    required this.heureDebut,
    required this.heureFin,
    required this.present,
    required this.dispense,
    required this.statut,
    this.commentaire,
    this.commentaireUser,
  });

  factory Cour.fromJson(Map<String, dynamic> json) {
    return Cour(
      id: json['id'],
      professeurNomComplet: json['professeur_nom_complet'],
      date: json['date'],
      heureDebut: json['heure_debut'],
      heureFin: json['heure_fin'],
      present: json['present'],
      dispense: json['dispense'],
      statut: json['statut'],
      commentaire: json['commentaire'],
      commentaireUser: json['commentaire_user'] ,
    );
  }
}
