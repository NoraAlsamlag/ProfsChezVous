// models/transaction.dart
class Transaction {
  final int id;
  final double montant;
  final String idTransaction;
  final double montantProf;
  final double montantAdmin;
  final DateTime dateCreation;
  final String statut;
  final int objectId;
  final int userId;
  final int professeurId;
  final int contentTypeId;

  Transaction({
    required this.id,
    required this.montant,
    required this.idTransaction,
    required this.montantProf,
    required this.montantAdmin,
    required this.dateCreation,
    required this.statut,
    required this.objectId,
    required this.userId,
    required this.professeurId,
    required this.contentTypeId,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      montant: double.parse(json['montant']),
      idTransaction: json['id_transaction'],
      montantProf: double.parse(json['montant_prof']),
      montantAdmin: double.parse(json['montant_admin']),
      dateCreation: DateTime.parse(json['date_creation']),
      statut: json['statut'],
      objectId: json['object_id'],
      userId: json['user'],
      professeurId: json['professeur'],
      contentTypeId: json['content_type'],
    );
  }
}
