import 'package:flutter/material.dart';

import '../../components/socal_card.dart';
import '../../constants.dart';
import 'composent/inscription_form.dart';

class InscriptionEcrant extends StatelessWidget {
  static String routeName = "/inscription";

  const InscriptionEcrant({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final String type = args?['type'] ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text("S'inscrire"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text("Créer un compte $type", style: headingStyle),
                  const Text(
                    "Complétez vos coordonnées ou continuez avec les médias sociaux.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  InscriptionForm(type: type),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocalCard(
                        icon: "assets/icons/google-icon.svg",
                        press: () {},
                      ),
                      SocalCard(
                        icon: "assets/icons/facebook-2.svg",
                        press: () {},
                      ),
                      SocalCard(
                        icon: "assets/icons/twitter.svg",
                        press: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'En continuant, vous confirmez que vous acceptez nos conditions générales.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}