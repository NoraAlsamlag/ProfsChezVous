import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profschezvousfrontend/api/auth/auth_api.dart';
import 'package:profschezvousfrontend/api/utilisateur/utilisateur_api.dart';
import 'package:profschezvousfrontend/models/user_models.dart';
import 'package:profschezvousfrontend/models/user_cubit.dart';

import '../../../constants.dart';

class EleveCompte extends StatefulWidget {
  static String routeName = "/eleve_compte";

  const EleveCompte({Key? key}) : super(key: key);

  @override
  _EleveCompteState createState() => _EleveCompteState();
}

class _EleveCompteState extends State<EleveCompte> {
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
        "Eleve Compte",
        style: TextStyle(color: kTextColor),
      ),
      backgroundColor: kPrimaryColor,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Type de profil", "Élève", Icons.person),
          _buildInfoRow("Nom", user.userDetails?.eleve?.nom ?? "", Icons.person),
          _buildInfoRow("Prénom", user.userDetails?.eleve?.prenom ?? "", Icons.person),
          _buildInfoRow("Ville", user.userDetails?.eleve?.ville ?? "", Icons.location_city),
          _buildInfoRow("Date de Naissance", user.userDetails?.eleve?.dateNaissance ?? "", Icons.calendar_today),
          _buildInfoRow("Numéro de Téléphone", user.userDetails?.eleve?.numeroTelephone ?? "", Icons.phone),
          _buildInfoRow("Niveau scolaire", user.userDetails?.eleve?.niveauScolaire ?? "", Icons.school),
          _buildInfoRow("Niveau scolaire", user.userDetails?.eleve?.etablissement ?? "", Icons.business),

        ],
      ),
    ),
  );
}

  String _getUserType(User user) {
    if (user.userDetails?.role == 'parent') {
      return 'parent';
    } else if (user.userDetails?.role == 'prof') {
      return 'Professeur';
    } else if (user.userDetails?.role == 'eleve') {
      return 'Élève';
    }
    return '';
  }

  String _getUserVille(User user) {
    if (user.userDetails?.role == 'Eleve') {
      return user.userDetails?.parent?.ville ?? "";
    } else if (user.userDetails?.role == 'prof') {
      return user.userDetails?.prof?.ville ?? "";
    } else if (user.userDetails?.role == 'eleve') {
      return user.userDetails?.eleve?.ville ?? "";
    }
    return "";
  }

  String _getUserDateNaissance(User user) {
    if (user.userDetails?.role == 'Eleve') {
      return user.userDetails?.parent?.dateNaissance ?? "";
    } else if (user.userDetails?.role == 'prof') {
      return user.userDetails?.prof?.dateNaissance ?? "";
    } else if (user.userDetails?.role == 'eleve') {
      return user.userDetails?.eleve?.dateNaissance ?? "";
    }
    return "";
  }

  String _getUserNumeroTelephone(User user) {
    if (user.userDetails?.role == 'Eleve') {
      return user.userDetails?.parent?.numeroTelephone ?? "";
    } else if (user.userDetails?.role == 'prof') {
      return user.userDetails?.prof?.numeroTelephone ?? "";
    } else if (user.userDetails?.role == 'eleve') {
      return user.userDetails?.eleve?.numeroTelephone ?? "";
    }
    return "";
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