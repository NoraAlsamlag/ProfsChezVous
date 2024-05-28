import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../constants.dart';
import '../../api/auth/auth_api.dart';
import 'package:intl/intl.dart';


class PageCoursReserves extends StatefulWidget {
  @override
  _PageCoursReservesState createState() => _PageCoursReservesState();
}

class _PageCoursReservesState extends State<PageCoursReserves> {
  bool isLoadingPackage = true;
  bool hasErrorPackage = false;
  bool isLoadingUnite = true;
  bool hasErrorUnite = false;
  List<Map<String, dynamic>> coursPackage = [];
  List<Map<String, dynamic>> coursUnite = [];

  @override
  void initState() {
    super.initState();
    _fetchCoursPackage();
    _fetchCoursUnite();
  }

  String formatDate(String date) {
  final DateTime dateTime = DateTime.parse(date);
  final DateFormat formatter = DateFormat('EEEE, d MMMM', 'fr_FR');
  return 'le ${formatter.format(dateTime)}';
}


  Future<void> _fetchCoursPackage() async {
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
          isLoadingPackage = false;
        });
      } else {
        setState(() {
          hasErrorPackage = true;
          isLoadingPackage = false;
        });
      }
    } catch (e) {
      setState(() {
        hasErrorPackage = true;
        isLoadingPackage = false;
      });
    }
  }

  Future<void> _fetchCoursUnite() async {
    try {
      String? token = await getToken();
      final response = await http.get(
        Uri.parse('$domaine/api/cours-unite-reserves/'),
        headers: {
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          coursUnite = List<Map<String, dynamic>>.from(data['cours_unite']);
          isLoadingUnite = false;
        });
      } else {
        setState(() {
          hasErrorUnite = true;
          isLoadingUnite = false;
        });
      }
    } catch (e) {
      setState(() {
        hasErrorUnite = true;
        isLoadingUnite = false;
      });
    }
  }

  Widget _buildCarteCoursPackage(Map<String, dynamic> cours) {
    Map<String, dynamic> disponibilites =
        jsonDecode(cours['selected_disponibilites']);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cours['description'],
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

  Widget _buildCarteCoursUnite(Map<String, dynamic> cours) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cours['sujet'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Date: ${formatDate(cours['date'])}'),
            Text('Heure début: ${cours['heure_debut']}'),
            Text('Heure fin: ${cours['heure_fine']}'),
            Text('Nombre d\'élèves: ${cours['nombre_eleves']}'),
            Text('Prix: ${cours['prix']} MRU'),
            Text(
              'Statut: ${cours['statut'] == 'R' ? 'Réservé' : cours['statut'] == 'C' ? 'Confirmé' : 'Annulé'}',
              style: TextStyle(
                color: cours['statut'] == 'R'
                    ? Colors.orange
                    : cours['statut'] == 'C'
                        ? Colors.green
                        : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
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

  Widget _buildCoursPackageList() {
    if (isLoadingPackage) {
      return const Center(child: CircularProgressIndicator());
    } else if (hasErrorPackage) {
      return const Center(
          child: Text('Erreur de chargement des cours réservés.'));
    } else {
      return ListView(
        padding: const EdgeInsets.all(15),
        children: coursPackage
            .map((cours) => _buildCarteCoursPackage(cours))
            .toList(),
      );
    }
  }

  Widget _buildCoursUniteList() {
    if (isLoadingUnite) {
      return const Center(child: CircularProgressIndicator());
    } else if (hasErrorUnite) {
      return const Center(
          child: Text('Erreur de chargement des cours réservés.'));
    } else {
      return ListView(
        padding: const EdgeInsets.all(15),
        children:
            coursUnite.map((cours) => _buildCarteCoursUnite(cours)).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mes Cours Réservés'),
          backgroundColor: kPrimaryColor,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Cours Package'),
              Tab(text: 'Cours Unite'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCoursPackageList(),
            _buildCoursUniteList(),
          ],
        ),
      ),
    );
  }
}
