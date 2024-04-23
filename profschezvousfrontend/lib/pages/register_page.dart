import 'package:flutter/material.dart';
import 'package:profschezvousfrontend/widgets/fields.dart';
import 'package:profschezvousfrontend/widgets/texxt_button.dart';

import '../theme.dart';
import 'login_page.dart';

class PageInscription extends StatelessWidget {
  const PageInscription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: defaultMargin,
        ),
        children: [
          Container(
            margin: EdgeInsets.only(top: 100),
            child: Text(
              "Inscrivez-vous maintenant !\n Inscrivez-vous dès maintenant pour accéder à toutes les fonctionnalités",
              style: whiteTextStyle.copyWith(
                fontSize: 20,
                fontWeight: semiBold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          ChampPersonnalise(
            iconUrl: 'assets/icon_name.png',
            hint: 'Nom Complet',
          ),
          ChampPersonnalise(
            iconUrl: 'assets/icon_email.png',
            hint: 'Email',
          ),
          ChampPersonnalise(
            iconUrl: 'assets/icon_password.png',
            hint: 'Mot de passe',
          ),
          ChampPersonnalise(
            iconUrl: 'assets/icon_password.png',
            hint: 'Confirmer le Mot de passe',
          ),
          BoutonTextePersonnalise(
            title: 'Inscription',
            margin: EdgeInsets.only(top: 50),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 40,
              bottom: 74,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PageConnexion()),
                    );
                  },
                  child: Text(
                    "Vous avez déjà un compte ? Connectez-vous",
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
