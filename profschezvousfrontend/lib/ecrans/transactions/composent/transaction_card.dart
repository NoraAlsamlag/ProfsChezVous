// transaction/composent/transaction_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/transaction_model.dart';
import 'transaction_detail_page.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final formatMonnaie = NumberFormat.currency(
      locale: 'fr_MR',
      symbol: 'MRU',
      decimalDigits: 2,
    );

    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text('Transaction: ${transaction.idTransaction}'),
        subtitle: Text(
          'Montant: ${formatMonnaie.format(transaction.montant)}\nStatut: ${transaction.statut}',
        ),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PageDetailTransaction(transaction: transaction),
            ),
          );
        },
      ),
    );
  }
}