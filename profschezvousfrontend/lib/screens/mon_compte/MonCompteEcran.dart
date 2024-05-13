import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profschezvousfrontend/api/auth/auth_api.dart';
import 'package:profschezvousfrontend/models/user_models.dart';
import 'package:profschezvousfrontend/models/user_cubit.dart';

import '../../constants.dart';
import '../profile/profile_type/parent_compte.dart';
import '../profile/profile_type/prof_compte.dart';

class MonCompteEcran extends StatefulWidget {
  static String routeName = "/mon_compte";

  const MonCompteEcran({Key? key}) : super(key: key);

  @override
  _MonCompteEcranState createState() => _MonCompteEcranState();
}

class _MonCompteEcranState extends State<MonCompteEcran> {
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
    } catch (e) {
      print("Erreur lors de la récupération des données utilisateur: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String type = userInfo?['user_type'] ?? '';
    print(userInfo?['user_type']);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
                  if (type == 'Parent') ...[
                    ParentCompte(),
                  ] else if (type == 'Professeur') ...[
                    ProfCompte(),
                  ] else if (type == 'Élève') ...[
                    ParentCompte(),
                  ],
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            ),
    );
  }
}
