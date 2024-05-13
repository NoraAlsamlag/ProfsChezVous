import 'package:flutter/material.dart';

import '../../constants.dart';
import 'inscription_ecrant.dart';

class PageInscription extends StatelessWidget {
  static String routeName = "/page_inscription";

  const PageInscription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Choisissez le type qui correspond à vous :',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  _buildCardButton(
                    icon: Icons.person,
                    label: 'Parent',
                    onPressed: () {
                      _navigateToInscriptionScreen(context, 'Parent');
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildCardButton(
                    icon: Icons.school,
                    label: 'Professeur',
                    onPressed: () {
                      _navigateToInscriptionScreen(context, 'Professeur');
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildCardButton(
                    icon: Icons.school,
                    label: 'Élève',
                    onPressed: () {
                      _navigateToInscriptionScreen(context, 'Élève');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: kPrimaryColor,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToInscriptionScreen(BuildContext context, String type) {
    Navigator.pushNamed(
      context,
      InscriptionEcrant.routeName,
      arguments: {
        'type': type,
      },
    );
  }
}