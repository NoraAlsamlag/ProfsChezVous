import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../../constants.dart';
import '../../models/user_cubit.dart';
import '../../models/user_models.dart';

import '../professeurs_list/composent/professeurs_list.dart';

class CoursUniteReservationPage extends StatefulWidget {
  final Professeur professeur;

  const CoursUniteReservationPage({Key? key, required this.professeur})
      : super(key: key);

  @override
  _CoursUniteReservationPageState createState() =>
      _CoursUniteReservationPageState();
}

class _CoursUniteReservationPageState extends State<CoursUniteReservationPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController sujetController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController prixController = TextEditingController();

  String? statut;
  int? matiereId;
  int? nombreEleves;
  int? duree;
  DateTime? dateFin;

  Map<String, List<String>> disponibilites = {};
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  String? selectedDay;
  String? selectedHeure;
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
              'Erreur de chargement des matières.';
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Erreur de chargement des matières.';
      });
    }
  }

  Future<void> _fetchPrix() async {
    if (matiereId != null && nombreEleves != null) {
      try {
        final response = await http.post(
          Uri.parse('$domaine/api/calculer-prix-cours-unite/'),
          body: jsonEncode({
            'matiere': matiereId,
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
                'Erreur de calcul du prix. Veuillez réessayer.'),
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

  String getSujetText() {
    if (sujetController.text.isEmpty ||
        sujetController.text == 'pas de sujet') {
      return 'Pas de sujet disponible';
    } else {
      return sujetController.text;
    }
  }

Future<void> _reserveCoursUnite() async {
  if (_formKey.currentState!.validate() &&
      selectedDay != null &&
      selectedHeure != null) {
    User user = context.read<UserCubit>().state;
    List<String> heures = selectedHeure!.split(' - ');
    String heureDebut = heures[0];
    String heureFin = heures[1];
    try {
      final response = await http.post(
        Uri.parse('$domaine/api/cours-unite/'),
        body: jsonEncode({
          'sujet': getSujetText(),
          'date': DateFormat('yyyy-MM-dd')
              .format(_getNextDateForDay(selectedDay!)),
          'statut': "R",
          'matiere': matiereId,
          'prix': prixController.text,
          'professeur': widget.professeur.id,
          'nombre_eleves': nombreEleves,
          'user': user.id,
          'selected_disponibilites': jsonEncode({
            "$selectedDay": ["$selectedHeure"]
          }),
          'heure_debut': heureDebut,
          'heure_fin': heureFin,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token ${user.token}',
        },
      );

      if (response.statusCode == 201) {
        await _removeDisponibilite(selectedDay!, selectedHeure!);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Réservation Confirmée'),
            content: const Text(
                'Vous avez réservé un cours en Unite avec les disponibilités choisies.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
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
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erreur'),
        content: const Text('Veuillez sélectionner une disponibilité.'),
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


  DateTime _getNextDateForDay(String day) {
    DateTime now = DateTime.now();
    List<String> daysOfWeek = [
      "lundi",
      "mardi",
      "mercredi",
      "jeudi",
      "vendredi",
      "samedi",
      "dimanche"
    ];
    int todayIndex = now.weekday - 1;
    int selectedIndex = daysOfWeek.indexOf(day);

    int difference = (selectedIndex - todayIndex) % 7;
    if (difference < 0) difference += 7;

    return now.add(Duration(days: difference));
  }

  List<String> _getDaysOfWeekStartingToday() {
    List<String> daysOfWeek = [
      "lundi",
      "mardi",
      "mercredi",
      "jeudi",
      "vendredi",
      "samedi",
      "dimanche"
    ];
    int todayIndex = DateTime.now().weekday - 1;
    return [
      ...daysOfWeek.sublist(todayIndex),
      ...daysOfWeek.sublist(0, todayIndex)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réserver un Cours en Unite'),
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
                          controller: sujetController,
                          decoration: const InputDecoration(
                              labelText: 'Sujet (Optionnel)'),
                          validator: (value) {
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
                              _fetchPrix();
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
                        for (var day in _getDaysOfWeekStartingToday())
                          ExpansionTile(
                            title: Text(day),
                            children: (disponibilites[day] ?? []).map((heure) {
                              bool isSelected =
                                  selectedDay == day && selectedHeure == heure;
                              return ListTile(
                                title: Text(heure),
                                trailing: Checkbox(
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedDay = day;
                                        selectedHeure = heure;
                                      } else {
                                        selectedDay = null;
                                        selectedHeure = null;
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
                            onPressed: _reserveCoursUnite,
                            child: const Text('Réserver le Unite'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
