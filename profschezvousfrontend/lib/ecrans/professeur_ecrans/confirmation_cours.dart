import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../constants.dart';
import '../../api/auth/auth_api.dart';
import '../../components/dialog_personnalise.dart';

class PageConfirmationCours extends StatefulWidget {
  const PageConfirmationCours({super.key});

  @override
  _PageConfirmationCoursState createState() => _PageConfirmationCoursState();
}

class _PageConfirmationCoursState extends State<PageConfirmationCours> {
  bool isLoading = true;
  bool hasError = false;
  List<Map<String, dynamic>> coursPackageNonConfirmes = [];
  List<Map<String, dynamic>> coursUniteNonConfirmes = [];

  @override
  void initState() {
    super.initState();
    _fetchCoursPackageNonConfirmes();
    _fetchCoursUniteNonConfirmes();
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
        _showErrorSnackBar(
            'Erreur de chargement des cours non confirmés. Code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      _showErrorSnackBar('Erreur de chargement des cours non confirmés : $e');
    }
  }

  Future<void> _fetchCoursUniteNonConfirmes() async {
    try {
      String? token = await getToken();
      final response = await http.get(
        Uri.parse('$domaine/api/professeur/cours-unite-non-confirmes/'),
        headers: {
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          coursUniteNonConfirmes = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
        _showErrorSnackBar(
            'Erreur de chargement des cours non confirmés. Code: ${response.statusCode}');
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
        final errorResponse = jsonDecode(response.body);
        setState(() {
          coursPackageNonConfirmes
              .removeWhere((cours) => cours['id'] == coursId);
        });
        _showSuccessSnackBar(
            'Cours confirmé avec succès. ${response.statusCode}.: ${errorResponse}');
      } else {
        final errorResponse = jsonDecode(response.body);
        _showErrorSnackBar(
            'Échec de la confirmation du cours. Code: ${response.statusCode}.\nErreur: ${errorResponse['error']}');
      }
    } catch (e) {
      _showErrorSnackBar('Erreur lors de la confirmation du cours : $e');
    }
  }

  Future<void> _confirmerCoursUnite(int coursId) async {
    try {
      String? token = await getToken();
      final response = await http.patch(
        Uri.parse('$domaine/api/professeur/confirmer-cours-unite/$coursId/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'est_actif': true}),
      );

      if (response.statusCode == 200) {
        setState(() {
          coursUniteNonConfirmes.removeWhere((cours) => cours['id'] == coursId);
        });
        _showSuccessSnackBar('Cours unité confirmé avec succès.');
      } else {
        _showErrorSnackBar(
            'Échec de la confirmation du cours unité. Code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackBar('Erreur lors de la confirmation du cours unité : $e');
    }
  }

  Future<void> _annulerCoursUnite(int coursId) async {
    try {
      String? token = await getToken();
      final response = await http.delete(
        Uri.parse('$domaine/api/professeur/annuler-cours-unite/$coursId/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          coursUniteNonConfirmes.removeWhere((cours) => cours['id'] == coursId);
        });
        _showSuccessSnackBar('Cours unité annulé avec succès.');
      } else {
        _showErrorSnackBar(
            'Échec de l\'annulation du cours unité. Code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackBar('Erreur lors de l\'annulation du cours unité : $e');
    }
  }

  Future<void> _montrerConfirmationDialogUnite(int coursId) async {
    await montrerDialogPersonnalise(
      context: context,
      titre: 'Confirmation',
      contenu: 'Voulez-vous vraiment confirmer ce cours unité ?',
      texteBoutonConfirmer: 'Confirmer',
      onConfirmer: () {
        _confirmerCoursUnite(coursId);
      },
      texteBoutonAnnuler: 'Annuler',
      onAnnuler: () {
        // Action supplémentaire si nécessaire lors de l'annulation
      },
    );
  }

  Future<void> _montrerAnnulationDialogUnite(int coursId) async {
    await montrerDialogPersonnalise(
      context: context,
      titre: 'Annulation',
      contenu: 'Voulez-vous vraiment annuler ce cours unité ?',
      texteBoutonConfirmer: 'Oui',
      onConfirmer: () {
        _annulerCoursUnite(coursId);
      },
      texteBoutonAnnuler: 'Non',
      onAnnuler: () {
        // Action supplémentaire si nécessaire lors de l'annulation
      },
    );
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
          coursPackageNonConfirmes
              .removeWhere((cours) => cours['id'] == coursId);
        });
        _showSuccessSnackBar('Cours annulé avec succès.');
      } else {
        _showErrorSnackBar(
            'Échec de l\'annulation du cours. Code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackBar('Erreur lors de l\'annulation du cours : $e');
    }
  }

  Future<void> _montrerConfirmationDialogPackage(int coursId) async {
    await montrerDialogPersonnalise(
      context: context,
      titre: 'Confirmation',
      contenu: 'Voulez-vous vraiment confirmer ce cours package ?',
      texteBoutonConfirmer: 'Confirmer',
      onConfirmer: () {
        _confirmerCoursPackage(coursId);
      },
      texteBoutonAnnuler: 'Annuler',
      onAnnuler: () {
        // Action supplémentaire si nécessaire lors de l'annulation
      },
    );
  }

  Future<void> _montrerAnnulationDialogPackage(int coursId) async {
    await montrerDialogPersonnalise(
      context: context,
      titre: 'Annulation',
      contenu: 'Voulez-vous vraiment annuler ce cours package ?',
      texteBoutonConfirmer: 'Oui',
      onConfirmer: () {
        _annulerCoursPackage(coursId);
      },
      texteBoutonAnnuler: 'Non',
      onAnnuler: () {
        // Action supplémentaire si nécessaire lors de l'annulation
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

  Widget _buildCarteCoursPakage(Map<String, dynamic> cours) {
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
                      onPressed: () =>
                          _montrerConfirmationDialogPackage(cours['id']),
                      child: const Text('Confirmer'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () =>
                          _montrerAnnulationDialogPackage(cours['id']),
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

  Widget _buildCarteCoursUnite(Map<String, dynamic> cours) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cours['sujet'] ?? 'Pas de sujet disponible',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Date: ${cours['date']}'),
            Text('Heure début: ${cours['heure_debut']}'),
            Text('Heure fin: ${cours['heure_fin']}'),
            Text('Nombre d\'élèves: ${cours['nombre_eleves']}'),
            Text('Prix: ${cours['prix']} MRU'),
            Text(
              'Statut: ${cours['statut'] == 'R' ? 'Réservé' : 'Inactif'}',
              style: TextStyle(
                color: cours['statut'] == 'R' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                      onPressed: () =>
                          _montrerConfirmationDialogUnite(cours['id']),
                      child: const Text('Confirmer'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () =>
                          _montrerAnnulationDialogUnite(cours['id']),
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Confirmation des Cours'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Cours & Package'),
              Tab(text: 'Cours & Unité'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCoursPackageTab(),
            _buildCoursUniteTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursPackageTab() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : hasError
            ? const Center(
                child: Text('Erreur de chargement des cours non confirmés.'))
            : ListView(
                padding: const EdgeInsets.all(15),
                children: coursPackageNonConfirmes
                    .map((cours) => _buildCarteCoursPakage(cours))
                    .toList(),
              );
  }

  Widget _buildCoursUniteTab() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : hasError
            ? const Center(
                child: Text('Erreur de chargement des cours non confirmés.'))
            : ListView(
                padding: const EdgeInsets.all(15),
                children: coursUniteNonConfirmes
                    .map((cours) => _buildCarteCoursUnite(cours))
                    .toList(),
              );
  }
}
