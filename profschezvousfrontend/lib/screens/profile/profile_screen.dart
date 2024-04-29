import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profschezvousfrontend/api/auth/auth_api.dart';
import 'package:profschezvousfrontend/screens/sign_in/sign_in_screen.dart';
import '../mon_compte/MonCompteEcran.dart';
import 'components/profile_menu.dart';
import 'components/profile_pic.dart';
import 'package:profschezvousfrontend/models/user_cubit.dart';
import 'package:profschezvousfrontend/models/user_models.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "Mon Compte",
              icon: "assets/icons/User Icon.svg",
              press: () {
                Navigator.pushNamed(context, MonCompteEcran.routeName);
              },
            ),
            ProfileMenu(
              text: "Notifications",
              icon: "assets/icons/Bell.svg",
              press: () {
                // Naviguer vers l'écran de Notifications
              },
            ),
            ProfileMenu(
              text: "Réglages",
              icon: "assets/icons/Settings.svg",
              press: () {
                // Naviguer vers l'écran de Réglages
              },
            ),
            ProfileMenu(
              text: "Centre d'Aide",
              icon: "assets/icons/Question mark.svg",
              press: () {
                // Naviguer vers le Centre d'Aide
              },
            ),
            ProfileMenu(
              text: "Déconnexion",
              icon: "assets/icons/Log out.svg",
              press: () {
                // Afficher la boîte de dialogue de confirmation avant la déconnexion
                afficherDialogueConfirmationDeconnexion(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void gererDeconnexion(BuildContext context, String? token) async {
    if (token != null) {
      try {
        await deconnexion(token);
        Navigator.pushNamedAndRemoveUntil(
            context, SignInScreen.routeName, (route) => false);
      } catch (e) {
        // Gérer l'erreur
        print('Erreur lors de la déconnexion: $e');
      }
    } else {
      // Le jeton est nul, ne peut pas déconnecter
      print('Le jeton est nul. Impossible de déconnecter.');
    }
  }

  void afficherDialogueConfirmationDeconnexion(BuildContext context) {
    User user = context.read<UserCubit>().state;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmer la Déconnexion"),
          content: const Text("Êtes-vous sûr de vouloir vous déconnecter?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                gererDeconnexion(
                    context, user.token); // Appeler la fonction de déconnexion
              },
              child: const Text("Déconnexion"),
            ),
          ],
        );
      },
    );
  }
}
