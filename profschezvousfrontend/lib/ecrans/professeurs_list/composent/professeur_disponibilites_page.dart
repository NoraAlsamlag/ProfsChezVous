import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../constants.dart';

class ProfesseurDisponibilitesPage extends StatefulWidget {
  final int? professeurId;

  const ProfesseurDisponibilitesPage({Key? key, required this.professeurId}) : super(key: key);

  @override
  _ProfesseurDisponibilitesPageState createState() => _ProfesseurDisponibilitesPageState();
}

class _ProfesseurDisponibilitesPageState extends State<ProfesseurDisponibilitesPage> {
  Map<String, List<String>> disponibilites = {
    "Lundi": [],
    "Mardi": [],
    "Mercredi": [],
    "Jeudi": [],
    "Vendredi": [],
    "Samedi": [],
    "Dimanche": []
  };

  List<String> heures = [
    "08:00 - 10:00",
    "11:00 - 13:00",
    "14:00 - 16:00",
    "15:00 - 17:00",
    "18:00 - 20:00"
  ];

  @override
  void initState() {
    super.initState();
    _fetchDisponibilites();
  }

  Future<void> _fetchDisponibilites() async {
    final response = await http.get(
      Uri.parse('$domaine/api/obtenir_disponibilites/${widget.professeurId}/'),
    );

    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> data = jsonDecode(response.body);
        data.forEach((date, times) {
          disponibilites[date] = List<String>.from(times);
        });
      });
    }
  }

  void _addDisponibilite(String day, String heure) async {
    final response = await http.post(
      Uri.parse('$domaine/api/ajouter_disponibilite/'),
      body: jsonEncode({
        'professeur_id': widget.professeurId,
        'date': day,
        'heure': heure,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        if (disponibilites[day] != null) {
          disponibilites[day]!.add(heure);
        } else {
          disponibilites[day] = [heure];
        }
      });
    }
  }

  void _removeDisponibilite(String day, String heure) async {
    final response = await http.post(
      Uri.parse('$domaine/api/supprimer_disponibilite/'),
      body: jsonEncode({
        'professeur_id': widget.professeurId,
        'date': day,
        'heure': heure,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        disponibilites[day]?.remove(heure);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter Disponibilités'),
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ajouter les créneaux horaires de disponibilité',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            for (var day in ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"])
              ExpansionTile(
                title: Text(day),
                children: heures.map((heure) {
                  return ListTile(
                    title: Text(heure),
                    trailing: Checkbox(
                      value: disponibilites[day]?.contains(heure) ?? false,
                      onChanged: (bool? value) {
                        if (value == true) {
                          _addDisponibilite(day, heure);
                        } else {
                          _removeDisponibilite(day, heure);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
