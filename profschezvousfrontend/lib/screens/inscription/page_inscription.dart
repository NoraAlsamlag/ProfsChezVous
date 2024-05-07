import 'package:flutter/material.dart';

import 'inscription_ecrant.dart';

class PageInscription extends StatelessWidget {
  static String routeName = "/page_inscription";

  const PageInscription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.person),
              label: Text('Parent'),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  InscriptionEcrant.routeName,
                  arguments: {
                    'type': 'parent',
                  },
                );
              },
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.school),
              label: Text('Professeur'),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  InscriptionEcrant.routeName,
                  arguments: {
                    'type': 'prof',
                  },
                );
              },
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.child_care),
              label: Text('Élève'),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  InscriptionEcrant.routeName,
                  arguments: {
                    'type': 'eleve',
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}