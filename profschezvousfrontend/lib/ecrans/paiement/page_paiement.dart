// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import '../../api/auth/auth_api.dart';
// import '../../constants.dart';

// class PagePaiement extends StatefulWidget {
//   @override
//   _PagePaiementState createState() => _PagePaiementState();
// }

// class _PagePaiementState extends State<PagePaiement> {
//   String? _idTransaction;
//   String? _messageErreur;
//   double? _montant;
//   double? _montantProf;
//   double? _montantAdmin;

//   Future<void> simulerPaiement(double montant, int professeurId, String coursType, int coursId) async {
//     final url = '$domaine/api/simuler-paiement/';
//     String? token = await getToken();
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Token $token',  // Assurez-vous de remplacer par un token JWT valide
//       },
//       body: json.encode({
//         'montant': (montant).toInt(),
//         'professeur_id': professeurId,
//         'cours_type': coursType,
//         'cours_id': coursId
//       }),  // Convertir les euros en centimes et ajouter les détails du cours
//     );
//     if (response.statusCode == 200) {
//       setState(() {
//         final responseData = json.decode(response.body);
//         _idTransaction = responseData['id_transaction'];
//         _montant = montant;
//         _montantProf = responseData['montant_prof'];  // Convertir les centimes en euros
//         _montantAdmin = responseData['montant_admin'];  // Convertir les centimes en euros
//         _messageErreur = null;
//       });
//     } else {
//       setState(() {
//         _messageErreur = json.decode(response.body)['erreur'];
//       });
//     }
//   }

//   void _gererPaiement() async {
//     await simulerPaiement(50.0, 2, 'unite', 1);  // Simuler un montant de paiement en euros, ID professeur, type de cours et ID du cours
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Page de Paiement'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               child: Text("Simuler le Paiement"),
//               onPressed: _gererPaiement,
//             ),
//             if (_idTransaction != null) 
//               Column(
//                 children: [
//                   Text('ID de Transaction : $_idTransaction'),
//                   Text('Montant Total: $_montant EUR'),
//                   Text('Montant pour le Prof: $_montantProf EUR'),
//                   Text('Montant pour les Admins: $_montantAdmin EUR'),
//                 ],
//               ),
//             if (_messageErreur != null) Text('Erreur : $_messageErreur'),
//           ],
//         ),
//       ),
//     );
//   }
// }
