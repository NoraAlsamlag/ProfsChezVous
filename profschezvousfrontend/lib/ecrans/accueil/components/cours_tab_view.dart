import 'package:flutter/material.dart';
import 'package:profschezvousfrontend/api/cours/cours_api.dart';
import '../../../components/format_date.dart';
import '../../../models/cour_model.dart';
import 'package:intl/intl.dart';


class CoursTabView extends StatefulWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  CoursTabView({required this.scaffoldMessengerKey});

  @override
  _CoursTabViewState createState() => _CoursTabViewState();
}

class _CoursTabViewState extends State<CoursTabView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Tous les Cours'),
            Tab(text: 'Cours à Venir'),
            Tab(text: 'Histoires des Cours'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              CoursList(endpoint: 'cours', scaffoldMessengerKey: widget.scaffoldMessengerKey),
              CoursList(endpoint: 'cours-a-venir', scaffoldMessengerKey: widget.scaffoldMessengerKey),
              CoursList(endpoint: 'cours-termines-ou-annules', scaffoldMessengerKey: widget.scaffoldMessengerKey),
            ],
          ),
        ),
      ],
    );
  }
}


class CoursList extends StatefulWidget {
  final String endpoint;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  CoursList({required this.endpoint, required this.scaffoldMessengerKey});

  @override
  _CoursListState createState() => _CoursListState();
}

class _CoursListState extends State<CoursList> {
  late Future<List<Cour>> futureCours;
  bool isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isLoaded) {
      futureCours = CourApi().fetchCours(widget.endpoint);
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cour>>(
      future: futureCours,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucun cours trouvé'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Cour cour = snapshot.data![index];
              return CourCard(cour: cour, scaffoldMessengerKey: widget.scaffoldMessengerKey);
            },
          );
        }
      },
    );
  }
}



class CourCard extends StatelessWidget {
  final Cour cour;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  CourCard({required this.cour, required this.scaffoldMessengerKey});

  @override
  Widget build(BuildContext context) {
    final DateTime currentDateTime = DateTime.now();
    final DateTime courseDate = DateTime.parse(cour.date);
    final TimeOfDay courseStartTime = TimeOfDay(
        hour: int.parse(cour.heureDebut.split(":")[0]),
        minute: int.parse(cour.heureDebut.split(":")[1]));
    final TimeOfDay courseEndTime = TimeOfDay(
        hour: int.parse(cour.heureFin.split(":")[0]),
        minute: int.parse(cour.heureFin.split(":")[1]));

    final DateTime courseStartDateTime = DateTime(
        courseDate.year,
        courseDate.month,
        courseDate.day,
        courseStartTime.hour,
        courseStartTime.minute);
    final DateTime courseEndDateTime = DateTime(
        courseDate.year,
        courseDate.month,
        courseDate.day,
        courseEndTime.hour,
        courseEndTime.minute);

    // Au début du cours, mettre à jour le statut à "En cours"
    if (currentDateTime.isAfter(courseStartDateTime) && currentDateTime.isBefore(courseEndDateTime) && cour.statut == 'AV') {
      _mettreAJourStatut(context, cour.id, 'EC');
    }

    // À la fin du cours, mettre à jour le statut à "Terminé"
    if (currentDateTime.isAfter(courseEndDateTime) && cour.statut == 'EC') {
      _mettreAJourStatut(context, cour.id, 'T');
      _mettreAJourDispense(context, cour.id, true);
    }

    String formatTime(String time) {
      final DateTime parsedTime = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("HH:mm").format(parsedTime);
    }

    String status = "Inconnu"; // Valeur par défaut
    Color statusColor = Colors.grey; // Couleur par défaut pour le statut inconnu

    switch (cour.statut) {
      case 'A':
        status = "Annulé";
        statusColor = Colors.red;
        break;
      case 'EC':
        status = "En cours";
        statusColor = Colors.orange;
        break;
      case 'AV':
        status = "À venir";
        statusColor = Colors.green;
        break;
      case 'T':
        status = "Terminé";
        statusColor = Colors.grey;
        break;
    }

    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cour.professeurNomComplet,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                CircleAvatar(
                  backgroundColor: statusColor,
                  radius: 5,
                ),
              ],
            ),
            SizedBox(height: 5),
            Text('Date: ${formatDate(courseDate)}'),
            Text('Heure: ${formatTime(cour.heureDebut)} - ${formatTime(cour.heureFin)}'),
            SizedBox(height: 10),
            if (cour.commentaire != null) Text('Commentaire: ${cour.commentaire}'),
            if (cour.commentaireUser != null) Text('Votre Commentaire: ${cour.commentaireUser}'),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  status,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                ),
                if (status == "En cours") ...[
                  IconButton(
                    icon: Icon(Icons.comment),
                    onPressed: () {
                      _montrerDialogCommentaire(context, cour);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.check_circle),
                    onPressed: () {
                      _montrerDialogPresence(context, cour);
                    },
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _montrerDialogCommentaire(BuildContext context, Cour cour) {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter un commentaire'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: "Écrire un commentaire"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Envoyer'),
              onPressed: () async {
                try {
                  await CourApi().ajouterCommentaire(cour.id, _controller.text);
                  Navigator.of(context).pop();
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(content: Text('Commentaire ajouté avec succès')),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(content: Text('Erreur : $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _montrerDialogPresence(BuildContext context, Cour cour) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Présence du professeur'),
          content: Text('Le professeur était-il présent pour ce cours ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Non'),
              onPressed: () {
                _mettreAJourPresence(context, cour.id, false);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Oui'),
              onPressed: () {
                _mettreAJourPresence(context, cour.id, true);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _mettreAJourPresence(BuildContext context, int coursId, bool present) async {
    try {
      final response = await CourApi().mettreAJourPresence(coursId, present);
      if (response.statusCode == 200) {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('Présence mise à jour avec succès.')),
        );
      } else {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('Erreur de mise à jour de la présence.')),
        );
      }
    } catch (e) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  void _mettreAJourStatut(BuildContext context, int coursId, String statut) async {
    try {
      final response = await CourApi().mettreAJourStatut(coursId, statut);
      if (response.statusCode == 200) {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('Statut mis à jour avec succès.')),
        );
      } else {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('Erreur de mise à jour du statut.')),
        );
      }
    } catch (e) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  void _mettreAJourDispense(BuildContext context, int coursId, bool dispense) async {
    try {
      final response = await CourApi().mettreAJourDispense(coursId, dispense);
      if (response.statusCode == 200) {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('Dispense mise à jour avec succès.')),
        );
      } else {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('Erreur de mise à jour de la dispense.')),
        );
      }
    } catch (e) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }
}
