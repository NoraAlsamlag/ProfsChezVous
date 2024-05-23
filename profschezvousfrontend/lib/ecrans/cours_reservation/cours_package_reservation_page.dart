import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../../constants.dart';
import '../../models/user_cubit.dart';
import '../../models/user_models.dart';
import '../professeurs_list/composent/professeur_detail_page.dart';
import '../professeurs_list/composent/professeurs_list.dart';

class PageReservationCoursPackage extends StatefulWidget {
  final Professeur professeur;

  const PageReservationCoursPackage({Key? key, required this.professeur})
      : super(key: key);

  @override
  _PageReservationCoursPackageState createState() =>
      _PageReservationCoursPackageState();
}

class _PageReservationCoursPackageState
    extends State<PageReservationCoursPackage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateDebutController = TextEditingController();
  TextEditingController prixController = TextEditingController();

  int? nombreSemaines;
  int? nombreEleves;
  String? heuresParSemaine;
  int? matiereId;
  int? duree;
  DateTime? dateFin;

  Map<String, List<String>> disponibilites = {};
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  Map<String, List<String>> selectedDisponibilites = {};
  List<Map<String, dynamic>> matieres = [];

  @override
  void initState() {
    super.initState();
    _fetchDisponibilites();
    _fetchMatieres();
  }

  Future<void> _fetchDisponibilites() async {
    try {
      final response = await http.get(
        Uri.parse(
            '$domaine/api/obtenir_disponibilites/${widget.professeur.id}/'),
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
          errorMessage =
              'Erreur de chargement des disponibilités. Code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Erreur de chargement des disponibilités : $e';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchMatieres() async {
    try {
      User user = context.read<UserCubit>().state;
      final response = await http.get(
        Uri.parse('$domaine/api/professeur/${widget.professeur.id}/matieres/'),
        headers: {
          'Authorization': 'Token ${user.token}',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          matieres = List<Map<String, dynamic>>.from(
              jsonDecode(utf8.decode(response.bodyBytes)));
        });
      } else {
        setState(() {
          hasError = true;
          errorMessage =
              'Erreur de chargement des matières. Code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Erreur de chargement des matières : $e';
      });
    }
  }

  int? _calculeTotalHeures() {
    if (selectedDisponibilites.isEmpty) {
      return null;
    }
    int totalHours = 0;
    selectedDisponibilites.forEach((day, hours) {
      totalHours += hours.length * 2;
    });
    return totalHours;
  }

  Future<void> _fetchPrix() async {
    int? nomdreHeuresParSemaine = _calculeTotalHeures();
    if (nombreSemaines != null &&
        nombreEleves != null &&
        nomdreHeuresParSemaine != null) {
      try {
        final response = await http.post(
          Uri.parse('$domaine/api/calculer-prix-cours-package/'),
          body: jsonEncode({
            'nombre_semaines': nombreSemaines,
            'heures_par_semaine': nomdreHeuresParSemaine,
            'nombre_eleves': nombreEleves,
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          double prix = data['prix'] is double
              ? data['prix']
              : double.parse(data['prix'].toString());
          setState(() {
            prixController.text = prix.toStringAsFixed(2);
          });
        } else {
          throw Exception('Erreur de calcul du prix');
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Erreur'),
            content: Text(
                'Erreur de calcul du prix. Veuillez réessayer.\n${e.toString()}'),
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
  }

  Future<void> _removeDisponibilite(String day, String heure) async {
    try {
      User user = context.read<UserCubit>().state;
      final response = await http.post(
        Uri.parse('$domaine/api/supprimer_disponibilite/'),
        body: jsonEncode({
          'professeur_id': widget.professeur.id,
          'date': day,
          'heure': heure,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token ${user.token}',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Erreur de suppression de la disponibilité');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erreur'),
          content: const Text(
              'Erreur de suppression de la disponibilité. Veuillez réessayer.'),
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

  Future<void> _reserveCoursForfait() async {
    if (_formKey.currentState!.validate()) {
      int? nomdreHeuresParSemaine = _calculeTotalHeures();
      // Calculer la durée
      duree = 7 * nombreSemaines!;

      DateTime dateDebut =
          DateFormat('yyyy-MM-dd').parse(dateDebutController.text);
      dateFin = dateDebut.add(Duration(days: duree!));

      try {
        User user = context.read<UserCubit>().state;
        final response = await http.post(
          Uri.parse('$domaine/api/cours-package/'),
          body: jsonEncode({
            'description': descriptionController.text,
            'duree': duree,
            'date_debut': dateDebutController.text,
            'date_fin': DateFormat('yyyy-MM-dd').format(dateFin!),
            'nombre_semaines': nombreSemaines,
            'nombre_eleves': nombreEleves,
            'heures_par_semaine': nomdreHeuresParSemaine,
            'matiere': matiereId,
            'prix': prixController.text,
            'selected_disponibilites': jsonEncode(selectedDisponibilites),
            'professeur': widget.professeur.id,
            'user': user.id,
          }),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token ${user.token}',
          },
        );

        if (response.statusCode == 201) {
          // Supprimer les disponibilités sélectionnées après la confirmation
          for (var day in selectedDisponibilites.keys) {
            for (var heure in selectedDisponibilites[day]!) {
              await _removeDisponibilite(day, heure);
            }
          }

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Réservation Confirmée'),
              content: const Text(
                  'Vous avez réservé un cours en forfait avec les disponibilités choisies.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfesseurDetailPage(professeur: widget.professeur),
                      ),
                    );
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
              content: const Text('Échec de la réservation.'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réserver un Cours en Forfait'),
        backgroundColor: kPrimaryColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                              labelText: 'Description (Optionnel)'),
                          validator: (value) {
                            return null; // Make sure the validator does not enforce this field
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: dateDebutController,
                          decoration:
                              const InputDecoration(labelText: 'Date de Début'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer la date de début';
                            }
                            return null;
                          },
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                dateDebutController.text =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<int>(
                          value: nombreSemaines,
                          decoration: const InputDecoration(
                              labelText: 'Nombre de Semaines'),
                          items: const [
                            DropdownMenuItem(
                                value: 1, child: Text('1 semaine')),
                            DropdownMenuItem(
                                value: 2, child: Text('2 semaines')),
                            DropdownMenuItem(
                                value: 3, child: Text('3 semaines')),
                            DropdownMenuItem(
                                value: 4, child: Text('4 semaines')),
                            DropdownMenuItem(
                                value: 5, child: Text('5 semaines')),
                            DropdownMenuItem(
                                value: 6, child: Text('6 semaines')),
                            DropdownMenuItem(
                                value: 7, child: Text('7 semaines')),
                            DropdownMenuItem(
                                value: 8, child: Text('8 semaines')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              nombreSemaines = value;
                              _fetchPrix();
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Veuillez sélectionner le nombre de semaines';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<int>(
                          value: nombreEleves,
                          decoration: const InputDecoration(
                              labelText: 'Nombre d\'Élèves'),
                          items: const [
                            DropdownMenuItem(value: 1, child: Text('1 élève')),
                            DropdownMenuItem(value: 2, child: Text('2 élèves')),
                            DropdownMenuItem(value: 3, child: Text('3 élèves')),
                            DropdownMenuItem(value: 4, child: Text('4 élèves')),
                            DropdownMenuItem(value: 5, child: Text('5 élèves')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              nombreEleves = value;
                              _fetchPrix();
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Veuillez sélectionner le nombre d\'élèves';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<int>(
                          value: matiereId,
                          decoration:
                              const InputDecoration(labelText: 'Matière'),
                          items: matieres.map<DropdownMenuItem<int>>((matiere) {
                            return DropdownMenuItem<int>(
                              value: matiere['id'],
                              child: Text('${matiere['symbole']}'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              matiereId = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Veuillez sélectionner une matière';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: prixController,
                          decoration: const InputDecoration(labelText: 'Prix'),
                          readOnly: true,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Disponibilités',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        for (var day in [
                          "Lundi",
                          "Mardi",
                          "Mercredi",
                          "Jeudi",
                          "Vendredi",
                          "Samedi",
                          "Dimanche"
                        ])
                          ExpansionTile(
                            title: Text(day),
                            children: (disponibilites[day] ?? []).map((heure) {
                              bool isSelected = selectedDisponibilites[day]
                                      ?.contains(heure) ??
                                  false;
                              return ListTile(
                                title: Text(heure),
                                trailing: Checkbox(
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        if (selectedDisponibilites[day] ==
                                            null) {
                                          selectedDisponibilites[day] = [];
                                        }
                                        selectedDisponibilites[day]!.add(heure);
                                      } else {
                                        selectedDisponibilites[day]
                                            ?.remove(heure);
                                      }
                                      _fetchPrix();
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                            ),
                            onPressed: _reserveCoursForfait,
                            child: const Text('Réserver le Forfait'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
