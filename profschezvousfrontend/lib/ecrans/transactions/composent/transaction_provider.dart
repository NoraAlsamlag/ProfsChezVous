// transaction/composent/transaction_provider.dart
import 'package:flutter/material.dart';
import 'package:profschezvousfrontend/api/transaction/transaction_api.dart';
import '../../../models/transaction_model.dart';
class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  List<Transaction> _filteredTransactions = [];
  bool _loading = false;
  String _searchQuery = '';

  List<Transaction> get transactions => _filteredTransactions;
  bool get loading => _loading;

  void fetchTransactions() async {
    _loading = true;
    notifyListeners();

    try {
      _transactions = await TransactionApi().fetchTransactions();
      _filteredTransactions = _transactions;
    } catch (e) {
      // Handle error if necessary
    }

    _loading = false;
    notifyListeners();
  }

  void filterTransactions(String query) {
    _searchQuery = query.toLowerCase();
    if (_searchQuery.isEmpty) {
      _filteredTransactions = _transactions;
    } else {
      _filteredTransactions = _transactions.where((transaction) {
        return transaction.idTransaction.toLowerCase().contains(_searchQuery) ||
               transaction.statut.toLowerCase().contains(_searchQuery);
      }).toList();
    }
    notifyListeners();
  }
}
