import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profschezvousfrontend/models/user_models.dart';
import 'package:profschezvousfrontend/models/user_cubit.dart';
import '../../../constants.dart';
import '../components/profile_pic.dart';

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

  Widget itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            color: Colors.deepOrange.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
        tileColor: Colors.white,
      ),
    );
  }

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
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ProfilePic(),
              const SizedBox(height: 20),
              itemProfile(
                "Type de profil",
                "Parent",
                Icons.person,
              ),
              const SizedBox(height: 20),
              itemProfile(
                "Nom",
                user.userDetails?.parent?.nom ?? "",
                Icons.person,
              ),
              const SizedBox(height: 20),
              itemProfile(
                "Prénom",
                user.userDetails?.parent?.prenom ?? "",
                Icons.person,
              ),
              const SizedBox(height: 20),
              itemProfile(
                "Ville",
                user.userDetails?.parent?.ville ?? "",
                Icons.location_city,
              ),
              const SizedBox(height: 20),
              itemProfile(
                "Date de Naissance",
                user.userDetails?.parent?.dateNaissance ?? "",
                Icons.calendar_today,
              ),
              const SizedBox(height: 20),
              itemProfile(
                "Numéro de Téléphone",
                user.userDetails?.parent?.numeroTelephone ?? "",
                Icons.phone,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}