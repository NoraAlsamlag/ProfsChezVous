import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../constants.dart';
import '../../api/auth/auth_api.dart';

class PageConfirmationCours extends StatefulWidget {
  const PageConfirmationCours({super.key});

  @override
  _PageConfirmationCoursState createState() => _PageConfirmationCoursState();
}

class _PageConfirmationCoursState extends State<PageConfirmationCours> {
  bool isLoading = true;
  bool hasError = false;
  List<Map<String, dynamic>> coursPackageNonConfirmes = [];

  @override
  void initState() {
    super.initState();
    _fetchCoursPackageNonConfirmes();
  }

  Future<void> _fetchCoursPackageNonConfirmes() async {
    try {
      String? token = await getToken();
      final response = await http.get(
        Uri.parse('$domaine/api/professeur/cours-package-non-confirmes/'),
        headers: {
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          coursPackageNonConfirmes = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
        _showErrorSnackBar('Erreur de chargement des cours non confirmés. Code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      _showErrorSnackBar('Erreur de chargement des cours non confirmés : $e');
    }
  }

  Future<void> _confirmerCoursPackage(int coursId) async {
    try {
      String? token = await getToken();
      final response = await http.patch(
        Uri.parse('$domaine/api/professeur/confirmer-cours-package/$coursId/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'est_actif': true}),
      );

      if (response.statusCode == 200) {
        setState(() {
          coursPackageNonConfirmes.removeWhere((cours) => cours['id'] == coursId);
        });
        _showSuccessSnackBar('Cours confirmé avec succès.');
      } else {
        _showErrorSnackBar('Échec de la confirmation du cours. Code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackBar('Erreur lors de la confirmation du cours : $e');
    }
  }

  Future<void> _annulerCoursPackage(int coursId) async {
    try {
      String? token = await getToken();
      final response = await http.delete(
        Uri.parse('$domaine/api/professeur/annuler-cours-package/$coursId/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          coursPackageNonConfirmes.removeWhere((cours) => cours['id'] == coursId);
        });
        _showSuccessSnackBar('Cours annulé avec succès.');
      } else {
        _showErrorSnackBar('Échec de l\'annulation du cours. Code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackBar('Erreur lors de l\'annulation du cours : $e');
    }
  }

  Future<void> _showConfirmationDialog(int coursId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Voulez-vous vraiment confirmer ce cours ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmer'),
              onPressed: () {
                Navigator.of(context).pop();
                _confirmerCoursPackage(coursId);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showCancellationDialog(int coursId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Annulation'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Voulez-vous vraiment annuler ce cours ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Non'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Oui'),
              onPressed: () {
                Navigator.of(context).pop();
                _annulerCoursPackage(coursId);
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildCarteCours(Map<String, dynamic> cours) {
    Map<String, dynamic> disponibilites;
    try {
      disponibilites = jsonDecode(cours['selected_disponibilites']);
    } catch (e) {
      disponibilites = {};
      _showErrorSnackBar('Erreur de décodage des disponibilités : $e');
    }
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
            const SizedBox(height: 10),
            const Text(
              'Emploi du Temps:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ..._buildEmploiDuTemps(disponibilites),
            const SizedBox(height: 10),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                      ),
                      onPressed: () => _showConfirmationDialog(cours['id']),
                      child: const Text('Confirmer'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => _showCancellationDialog(cours['id']),
                      child: const Text('Annuler'),
                    ),
                  ),
                ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation des Cours en Forfait'),
        backgroundColor: kPrimaryColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const Center(child: Text('Erreur de chargement des cours non confirmés.'))
              : ListView(
                  padding: const EdgeInsets.all(15),
                  children: coursPackageNonConfirmes.map((cours) => _buildCarteCours(cours)).toList(),
                ),
    );
  }
}
