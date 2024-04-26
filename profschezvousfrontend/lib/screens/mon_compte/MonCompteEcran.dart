import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profschezvousfrontend/api/auth/auth_api.dart';
import 'package:profschezvousfrontend/models/user_models.dart';
import 'package:profschezvousfrontend/models/user_cubit.dart';

class MonCompteEcran extends StatefulWidget {
  static String routeName = "/mon_compte";

  const MonCompteEcran({Key? key}) : super(key: key);

  @override
  _MonCompteEcranState createState() => _MonCompteEcranState();
}

class _MonCompteEcranState extends State<MonCompteEcran> {
  Map<String, dynamic>? userInfo;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    User user = context.read<UserCubit>().state;
    try {
      // Remplacez 'userPk' par la clé primaire réelle de l'utilisateur connecté
      int? userPk = user.id; // Exemple : clé primaire de l'utilisateur connecté
      var data = await getUserInfo(userPk);
      setState(() {
        userInfo = data;
      });
    } catch (e) {
      print("Erreur lors de la récupération des données utilisateur: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mon Compte"),
      ),
      body: userInfo != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow("Type de profile", userInfo!['user_type'], Icons.person),
                  _buildInfoRow("Nom", userInfo!['details']['nom'], Icons.person),
                  _buildInfoRow("Prénom", userInfo!['details']['prenom'], Icons.person),
                  _buildInfoRow("Adresse", userInfo!['details']['adresse'], Icons.location_on),
                  _buildInfoRow("Ville", userInfo!['details']['ville'], Icons.location_city),
                  _buildInfoRow("Date de Naissance", userInfo!['details']['date_naissance'], Icons.calendar_today),
                  _buildInfoRow("Numéro de Téléphone", userInfo!['details']['numero_telephone'], Icons.phone),
                  // Ajoutez d'autres informations utilisateur ici
                ],
              ),
            )

          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 8),
          Text(
            "$label: $value",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}