import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profschezvousfrontend/api/auth/auth_api.dart';
import 'package:profschezvousfrontend/ecrans/sign_in/sign_in_screen.dart';
import '../notification/notification_ecrant.dart';
import '../professeurs_list/composent/professeur_disponibilites_page.dart';
import '../transactions/transactions_ecran.dart';
import 'profile_type/eleve_compte.dart';
import 'profile_type/parent_compte.dart';
import 'profile_type/prof_compte.dart';
import 'components/profile_menu.dart';
import 'components/profile_pic.dart';
import 'package:profschezvousfrontend/models/user_cubit.dart';
import 'package:profschezvousfrontend/models/user_models.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      User user = context.read<UserCubit>().state;
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Profil",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ProfilePic(),
                const SizedBox(height: 20),
                ProfileMenu(
                  text: "Mon Compte",
                  icon: "assets/icons/User Icon.svg",
                  press: () {
                    if (user.isParent == true) {
                      Navigator.pushNamed(context, ParentCompte.routeName);
                    } else if (user.isProfesseur == true) {
                      Navigator.pushNamed(context, ProfCompte.routeName);
                    } else if (user.isEleve == true) {
                      Navigator.pushNamed(context, EleveCompte.routeName);
                    }
                  },
                ),
                ProfileMenu(
                  text: "Notifications",
                  icon: "assets/icons/Bell.svg",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationEcrant()),
                    );
                  },
                ),
                if (user.isProfesseur == true)
                  ProfileMenu(
                    text: "Mes Disponibilités",
                    icon: "assets/icons/Bell.svg",
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfesseurDisponibilitesPage(professeurId: user.userDetails?.prof?.userId),
                        ),
                      );
                    },
                  ),
                ProfileMenu(
                  text: "Réglages",
                  icon: "assets/icons/Settings.svg",
                  press: () {
                    print("Navigating to settings");
                    // Navigate to the Settings screen
                  },
                ),
                ProfileMenu(
                  text: "Transactions",
                  icon: "assets/icons/Bell.svg",
                  press: () {
                    Navigator.pushNamed(context, TransactionsEcran.routeName);
                  },
                ),
                ProfileMenu(
                  text: "Centre d'Aide",
                  icon: "assets/icons/Question mark.svg",
                  press: () {
                    // Navigate to the Help Center screen
                  },
                ),
                ProfileMenu(
                  text: "Déconnexion",
                  icon: "assets/icons/Log out.svg",
                  press: () {
                    afficherDialogueConfirmationDeconnexion(context);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      print('Exception caught: $e');
      return Scaffold(
        body: Center(
          child: Text('Une erreur s\'est produite. Veuillez réessayer plus tard.'),
        ),
      );
    }
  }

  void gererDeconnexion(BuildContext context, String? token) async {
    try {
      if (token != null) {
        await deconnexion(token);
        Navigator.pushNamedAndRemoveUntil(
            context, SignInScreen.routeName, (route) => false);
      } else {
        print('Le jeton est nul. Impossible de déconnecter.');
      }
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
    }
  }

  void afficherDialogueConfirmationDeconnexion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmer la Déconnexion"),
          content: const Text("Êtes-vous sûr de vouloir vous déconnecter?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                try {
                  User user = context.read<UserCubit>().state;
                  gererDeconnexion(context, user.token);
                } catch (e) {
                  print('Erreur lors de la déconnexion: $e');
                }
              },
              child: const Text("Déconnexion"),
            ),
          ],
        );
      },
    );
  }
}
