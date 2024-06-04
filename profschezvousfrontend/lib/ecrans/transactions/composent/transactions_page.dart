// transaction/composent/transactions_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'transaction_provider.dart';
import 'transaction_card.dart';

class TransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (query) {
              Provider.of<TransactionProvider>(context, listen: false)
                  .filterTransactions(query);
            },
          ),
        ),
        Expanded(
          child: Consumer<TransactionProvider>(
            builder: (context, provider, child) {
              if (provider.loading) {
                return Center(child: CircularProgressIndicator());
              }

              if (provider.transactions.isEmpty) {
                return Center(child: Text('Aucune transaction disponible'));
              }

              return ListView.builder(
                itemCount: provider.transactions.length,
                itemBuilder: (context, index) {
                  final transaction = provider.transactions[index];
                  return TransactionCard(transaction: transaction);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
