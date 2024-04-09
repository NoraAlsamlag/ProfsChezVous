import 'package:flutter/material.dart';
import 'package:profschezvousfrontend/components/button.dart';
import 'package:profschezvousfrontend/components/textfield.dart';
import 'package:profschezvousfrontend/components/square_tile.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // contrôleurs de champs de texte
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // méthode de connexion de l'utilisateur
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // logo
              const Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(height: 50),

              // bienvenue, vous nous avez manqué !
              Text(
                'Bienvenue, vous nous avez manqué !',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              // champ de texte pour le nom d'utilisateur
              MyTextField(
                controller: usernameController,
                hintText: 'Nom d\'utilisateur',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // champ de texte pour le mot de passe
              MyTextField(
                controller: passwordController,
                hintText: 'Mot de passe',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // mot de passe oublié ?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Mot de passe oublié ?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // bouton de connexion
              MyButton(
                onTap: signUserIn,
              ),

              const SizedBox(height: 50),

              // ou continuer avec
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Ou continuer avec',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // boutons de connexion Google + Apple
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // bouton Google
                  const SquareTile(imagePath: 'lib/images/google.png'),

                  const SizedBox(width: 25),

                  // bouton Apple
                  const SquareTile(imagePath: 'lib/images/apple.png')
                ],
              ),

              const SizedBox(height: 50),

              // pas encore membre ? inscrivez-vous maintenant
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pas encore membre ?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Inscrivez-vous maintenant',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
