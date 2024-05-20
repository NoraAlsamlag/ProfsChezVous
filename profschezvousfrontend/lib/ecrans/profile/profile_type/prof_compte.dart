import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profschezvousfrontend/models/user_models.dart';
import 'package:profschezvousfrontend/models/user_cubit.dart';

import '../../../constants.dart';

class ProfCompte extends StatefulWidget {
  static String routeName = "/prof_compte";

  const ProfCompte({Key? key}) : super(key: key);

  @override
  _ProfCompteState createState() => _ProfCompteState();
}

class _ProfCompteState extends State<ProfCompte> {
  User? user;

  @override
  void initState() {
    super.initState();
    // Retrieve user data
    // getUserData();
  }


  @override
Widget build(BuildContext context) {
  User user = context.read<UserCubit>().state;

  return Scaffold(
    appBar: AppBar(
      title: const Text(
        "Professeur Compte",
        style: TextStyle(color: kTextColor),
      ),
      backgroundColor: kPrimaryColor,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Type de profil", "Professeur", Icons.person),
          _buildInfoRow("Nom", user.userDetails?.prof?.nom ?? "", Icons.person),
          _buildInfoRow("Prénom", user.userDetails?.prof?.prenom ?? "", Icons.person),
          _buildInfoRow("Ville", user.userDetails?.prof?.ville ?? "", Icons.location_city),
          _buildInfoRow("Date de Naissance", user.userDetails?.prof?.dateNaissance ?? "", Icons.calendar_today),
          _buildInfoRow("Numéro de Téléphone", user.userDetails?.prof?.numeroTelephone ?? "", Icons.phone),
          _buildInfoRow("Niveau etude", user.userDetails?.prof?.niveauEtude ?? "", Icons.school),
          _buildInfoRow("Matiere a enseigner", user.userDetails?.prof?.matieresAEnseigner.join(', ') ?? "", Icons.school),

        ],
      ),
    ),
  );
}



  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: kPrimaryColor,
          ),
          SizedBox(width: 8),
          Text(
            "$label: $value",
            style: TextStyle(fontSize: 18, color: kTextColor),
          ),
        ],
      ),
    );
  }
}