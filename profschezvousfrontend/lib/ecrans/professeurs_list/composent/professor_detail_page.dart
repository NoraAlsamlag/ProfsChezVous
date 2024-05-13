import 'package:flutter/material.dart';
import 'package:profschezvousfrontend/ecrans/professeurs_list/composent/professeurs_list.dart';
import '../../../constants.dart';

class ProfesseurDetailPage extends StatelessWidget {
  static String routeName = "/professor_detail_page";
  final Professeur professor;

  const ProfesseurDetailPage({Key? key, required this.professor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du Professeur'),
        backgroundColor:kPrimaryColor, // Enhanced AppBar color
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 90, // Increased size for better visibility
              backgroundImage:
                  NetworkImage('${domaine}${professor.imageProfile}'),
              backgroundColor: Colors.grey[200], // Softer color for background
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(professor.nom,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color:kPrimaryColor, // Theme color for text
                      )),
                  SizedBox(height: 10),
                  Text('Latitude: ${professor.latitude}',
                      style: TextStyle(fontSize: 18, color: Colors.grey[700])),
                  Text('Longitude: ${professor.longitude}',
                      style: TextStyle(fontSize: 18, color: Colors.grey[700])),
                  SizedBox(height: 10),
                  Text('Matières à enseigner: ${professor.matiereAenseigner}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  Text('Adresse: ${professor.adresse}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                          kPrimaryColor, // Button background color
                        foregroundColor: Colors.white, // Text color
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Confirmation'),
                            content: Text(
                                'Voulez-vous réserver un cours avec ${professor.nom}?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  // Add booking logic here
                                },
                                child: Text('Oui'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Non'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text('Réserver un cours avec ce professeur'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
