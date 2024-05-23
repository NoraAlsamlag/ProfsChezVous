import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:profschezvousfrontend/ecrans/professeurs_list/composent/professeurs_list.dart';
import '../../../constants.dart';
import '../../cours_reservation/cours_unite_reservation_page.dart';
import '../../cours_reservation/cours_package_reservation_page.dart';

class ProfesseurDetailPage extends StatefulWidget {
  static String routeName = "/professeur_detail_page";
  final Professeur professeur;

  const ProfesseurDetailPage({Key? key, required this.professeur}) : super(key: key);

  @override
  _ProfesseurDetailPageState createState() => _ProfesseurDetailPageState();
}

class _ProfesseurDetailPageState extends State<ProfesseurDetailPage> {
  Map<String, List<String>> disponibilites = {};
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchDisponibilites();
  }

  Future<void> _fetchDisponibilites() async {
    try {
      final response = await http.get(
        Uri.parse('$domaine/api/obtenir_disponibilites/${widget.professeur.id}/'),
      );

      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> data = jsonDecode(response.body);
          data.forEach((date, times) {
            disponibilites[date] = List<String>.from(times);
          });
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> _reserveCours(String day, String heure) async {
    try {
      final response = await http.post(
        Uri.parse('$domaine/api/reserver_disponibilite/'),
        body: jsonEncode({
          'professeur_id': widget.professeur.id,
          'date': day,
          'heure': heure,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Réservation Confirmée'),
            content: Text('Vous avez réservé un cours de $heure le $day avec ${widget.professeur.nom}.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Erreur'),
            content: const Text('Échec de la réservation. Veuillez réessayer.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erreur'),
          content: const Text('Échec de la réservation. Veuillez réessayer.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Professeur'),
        backgroundColor: kPrimaryColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const Center(child: Text('Erreur de chargement des disponibilités.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 90,
                        backgroundImage: NetworkImage('${domaine}${widget.professeur.imageProfile}'),
                        backgroundColor: Colors.grey[200],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.professeur.nom,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Matières à enseigner: ${widget.professeur.matieresAenseigner.join(', ')}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Adresse: ${widget.professeur.adresse}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      // const SizedBox(height: 30),
                      // const Text(
                      //   'Disponibilités',
                      //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      // ),
                      // for (var day in ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"])
                      //   ExpansionTile(
                      //     title: Text(day),
                      //     children: (disponibilites[day] ?? []).map((heure) {
                      //       return ListTile(
                      //         title: Text(heure),
                      //         trailing: SizedBox(
                      //           width: 120,
                      //           child: ElevatedButton(
                      //             onPressed: () => _reserveCours(day, heure),
                      //             child: const Text('Réserver'),
                      //           ),
                      //         ),
                      //       );
                      //     }).toList(),
                      //   ),
                      const SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CoursUniteReservationPage(professeur: widget.professeur),
                                  ),
                                );
                              },
                              child: const Text('Réserver un Cours Unitaire'),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PageReservationCoursPackage(professeur: widget.professeur),
                                  ),
                                );
                              },
                              child: const Text('Réserver un Cours en Forfait'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
