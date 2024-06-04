// transaction/transactions_ecran.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'composent/transaction_provider.dart';
import 'composent/transactions_page.dart';

class TransactionsEcran extends StatelessWidget {
  static String routeName = "/transactionEcran";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TransactionProvider()..fetchTransactions(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Transactions'),
        ),
        body: SafeArea(
          child: TransactionsPage(),
        ),
      ),
    );
  }
}
