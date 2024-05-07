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
  Map<String, dynamic>? userInfo;
  String? address;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    User user = context.read<UserCubit>().state;
    try {
      int? userPk = user.id;

      var data = await getUserInfo(userPk);
      setState(() {
        userInfo = data;
      });

      if (userInfo != null && userInfo!['details'] != null) {
        double? latitude = userInfo!['details']['latitude'] as double?;
        double? longitude = userInfo!['details']['longitude'] as double?;

        if (latitude != null && longitude != null) {
          address = await obtenirAdresseAPartirDesCoordinates(latitude, longitude);
          setState(() {
            address = address;
          });
        }
      }
    } catch (e) {
      print("Erreur lors de la récupération des données utilisateur: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mon Compte",
          style: TextStyle(color: kTextColor),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: userInfo != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow("Type de profil", userInfo!['user_type'], Icons.person),
                  _buildInfoRow("Nom", userInfo!['details']['nom'], Icons.person),
                  _buildInfoRow("Prénom", userInfo!['details']['prenom'], Icons.person),
                  _buildInfoRow("Adresse", address ?? '', Icons.location_on),
                  _buildInfoRow("Ville", userInfo!['details']['ville'], Icons.location_city),
                  _buildInfoRow("Date de Naissance", userInfo!['details']['date_naissance'], Icons.calendar_today),
                  _buildInfoRow("Numéro de Téléphone", userInfo!['details']['numero_telephone'], Icons.phone),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String? value, IconData icon) {
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
            "$label: ${value ?? ''}",
            style: TextStyle(fontSize: 18, color: kTextColor),
          ),
        ],
      ),
    );
  }
}