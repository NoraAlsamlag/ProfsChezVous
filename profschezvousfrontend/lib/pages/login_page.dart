import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profschezvousfrontend/models/user_models.dart';
import 'package:profschezvousfrontend/pages/EcranPrincipal.dart';
import 'package:profschezvousfrontend/pages/home/home.dart';

import '../api/auth/auth_api.dart';
import '../models/user_cubit.dart';
import '../theme.dart';
import '../widgets/fields.dart';
import '../widgets/texxt_button.dart';
import 'forget_pass.dart';
import 'register_page.dart';

class PageConnexion extends StatefulWidget {
  const PageConnexion({Key? key}) : super(key: key);

  @override
  State<PageConnexion> createState() => _PageConnexionState();
}

class _PageConnexionState extends State<PageConnexion> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implémenter initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implémenter dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: defaultMargin,
        ),
        children: [
          // Container(
          //   margin: EdgeInsets.only(top: 50),
          //   child: Image.asset(
          //     'assets/img_login.png',
          //   ),
          // ),
          SizedBox(
            height: 155,
          ),
          ChampPersonnalise(
            controller: emailController,
            iconUrl: 'assets/icon_email.png',
            hint: 'Email',
          ),
          ChampPersonnalise(
            controller: passwordController,
            iconUrl: 'assets/icon_password.png',
            hint: 'Mot de passe',
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PageMotDePasseOublie()),
                  );
                },
                child: Text(
                  "Mot de passe oublié ?",
                  style: whiteTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),
              ),
            ),
          ),
          // Connexion
          BoutonTextePersonnalise(
            onTap: () async {
              var authRes =
                  await authentificationUtilisateur(emailController.text, passwordController.text);
              if (authRes.runtimeType == String) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Container(
                          alignment: Alignment.center,
                          height: 200,
                          width: 250,
                          decoration: BoxDecoration(),
                          child: Text(authRes)),
                    );
                  },
                );
              } else if (authRes.runtimeType == User) {
                User utilisateur = authRes;
                context.read<UserCubit>().emit(utilisateur);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return EcranPrincipal();
                  },
                ));
              }
            },
            title: 'Connexion',
            margin: EdgeInsets.only(top: 50),
          ),
          //
          Container(
            margin: EdgeInsets.only(
              top: 30,
              bottom: 74,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PageInscription()),
                    );
                  },
                  child: Text(
                    "Pas encore de compte ? Inscrivez-vous",
                    style: whiteTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
