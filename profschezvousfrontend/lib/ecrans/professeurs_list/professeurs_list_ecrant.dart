import 'package:flutter/material.dart';
import 'composent/professeurs_list.dart';
// Import other components if they are in different files.

class ProfesseursListEcrant extends StatelessWidget {
  const ProfesseursListEcrant({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView( // Allows the page to be scrollable
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Professeurs",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              // HomeHeader(), // Example widget, define this according to your needs
              SizedBox(height: 10),
              ProfesseursList(), // Already defined in your components
              // SizedBox(height: 20),
              // SpecialOffers(), // Example widget, define this according to your needs
              // SizedBox(height: 20),
              // PopularProducts(), // Example widget, define this according to your needs
              // SizedBox(height: 20),
              // Text("Accueil", style: TextStyle(fontSize: 18)), // Simple text widget
              // SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
