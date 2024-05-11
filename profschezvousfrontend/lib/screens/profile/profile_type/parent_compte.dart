import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profschezvousfrontend/api/auth/auth_api.dart';
import 'package:profschezvousfrontend/api/utilisateur/utilisateur_api.dart';
import 'package:profschezvousfrontend/models/user_models.dart';
import 'package:profschezvousfrontend/models/user_cubit.dart';

import '../../../constants.dart';

class ParentCompte extends StatefulWidget {
  static String routeName = "/parent_compte";

  const ParentCompte({Key? key}) : super(key: key);

  @override
  _ParentCompteState createState() => _ParentCompteState();
}

class _ParentCompteState extends State<ParentCompte> {
  User? user;

  @override
  void initState() {
    super.initState();
    // Retrieve user data
    // getUserData();
  }

  // Future<void> getUserData() async {
  //   final token = await getTokenFromHive();
  //   if (token != null) {
  //     user = await getUser(token);
  //     if (user != null) {
  //       setState(() {
  //         // Update the user state in UserCubit
  //         context.read<UserCubit>().updateUser(user!);
  //       });
  //     }
  //   }
  // }

  @override
Widget build(BuildContext context) {
  User user = context.read<UserCubit>().state;

  return Scaffold(
    appBar: AppBar(
      title: const Text(
        "Parent Compte",
        style: TextStyle(color: kTextColor),
      ),
      backgroundColor: kPrimaryColor,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Type de profil", "Parent", Icons.person),
          _buildInfoRow("Nom", user.userDetails?.parent?.nom ?? "", Icons.person),
          _buildInfoRow("Prénom", user.userDetails?.parent?.prenom ?? "", Icons.person),
          _buildInfoRow("Ville", user.userDetails?.parent?.ville ?? "", Icons.location_city),
          _buildInfoRow("Date de Naissance", user.userDetails?.parent?.dateNaissance ?? "", Icons.calendar_today),
          _buildInfoRow("Numéro de Téléphone", user.userDetails?.parent?.numeroTelephone ?? "", Icons.phone),

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