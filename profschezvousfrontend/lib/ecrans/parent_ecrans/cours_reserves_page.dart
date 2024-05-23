import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../constants.dart';
import '../../api/auth/auth_api.dart';

class PageCoursReserves extends StatefulWidget {
  @override
  _PageCoursReservesState createState() => _PageCoursReservesState();
}

class _PageCoursReservesState extends State<PageCoursReserves> {
  bool isLoading = true;
  bool hasError = false;
  List<Map<String, dynamic>> coursPackage = [];

  @override
  void initState() {
    super.initState();
    _fetchCoursReserves();
  }

  Future<void> _fetchCoursReserves() async {
    try {
      String? token = await getToken();
      final response = await http.get(
        Uri.parse('$domaine/api/cours-package-reserves/'),
        headers: {
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          coursPackage = List<Map<String, dynamic>>.from(data['cours_package']);
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

  Widget _buildCarteCours(Map<String, dynamic> cours) {
    Map<String, dynamic> disponibilites = jsonDecode(cours['selected_disponibilites']);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cours['description'] ?? 'Pas de description',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Début: ${cours['date_debut']}'),
            Text('Fin: ${cours['date_fin']}'),
            Text('Nombre de semaines: ${cours['nombre_semaines']}'),
            Text('Nombre d\'élèves: ${cours['nombre_eleves']}'),
            Text('Prix: ${cours['prix']} MRU'),
            Text(
              'Statut: ${cours['est_actif'] ? 'Actif' : 'Inactif'}',
              style: TextStyle(
                color: cours['est_actif'] ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Emploi du Temps:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ..._buildEmploiDuTemps(disponibilites),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildEmploiDuTemps(Map<String, dynamic> disponibilites) {
    List<Widget> emploiDuTempsWidgets = [];
    disponibilites.forEach((jour, heures) {
      emploiDuTempsWidgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '$jour: ${heures.join(', ')}',
            style: const TextStyle(fontSize: 14),
          ),
        ),
      );
    });
    return emploiDuTempsWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Cours Réservés'),
        backgroundColor: kPrimaryColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const Center(child: Text('Erreur de chargement des cours réservés.'))
              : ListView(
                  padding: const EdgeInsets.all(15),
                  children: coursPackage
                      .map((cours) => _buildCarteCours(cours))
                      .toList(),
                ),
    );
  }
}
