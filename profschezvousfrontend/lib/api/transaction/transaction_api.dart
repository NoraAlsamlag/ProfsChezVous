import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:profschezvousfrontend/api/auth/auth_api.dart';
import 'package:profschezvousfrontend/constants.dart';
import '../../models/transaction_model.dart';

class TransactionApi {
   static const String baseUrl = '$domaine/api';
    

  Future<List<Transaction>> fetchTransactions() async {
    String? token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/transactions/'),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Transaction.fromJson(data)).toList();
    } else {
      throw Exception('Échec de chargement des transactions');
    }
  }
}
