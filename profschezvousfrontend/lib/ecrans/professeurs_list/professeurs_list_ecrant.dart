import 'package:flutter/material.dart';
import 'composent/professeurs_list.dart';

class ProfesseursListEcrant extends StatelessWidget {
  const ProfesseursListEcrant({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Professeurs",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: ProfesseursList(),
            ),
          ],
        ),
      ),
    );
  }
}
