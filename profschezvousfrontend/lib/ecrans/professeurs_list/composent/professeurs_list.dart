import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../api/prof/prof_api.dart';
import '../../../constants.dart';
import 'professor_detail_page.dart';

class ProfesseursList extends StatefulWidget {
  @override
  _ProfesseursListState createState() => _ProfesseursListState();
}

class _ProfesseursListState extends State<ProfesseursList> {
  String? selectedProfesseur;
  List<Professeur> professeurs = [];
  List<Professeur> filteredProfesseurs = [];
  TextEditingController searchController = TextEditingController();

  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    obtenirProfesseurs().then((data) {
      List<dynamic> professeursData = data;
      professeurs = professeursData.map((item) {
        return Professeur(
          id: item['user_id'],
          nom: '${item['prenom']} ${item['nom']}',
          latitude: item['latitude'],
          longitude: item['longitude'],
          matiereAenseigner: item['matiere_a_enseigner'],
          adresse: item['adresse'],
          imageProfile: item['image_profil'] ?? userDefaultImage,
        );
      }).toList();
      filteredProfesseurs = List<Professeur>.from(professeurs);
      setState(() {});
    });
  }

  void updateSearchQuery(String query) {
    setState(() {
      filteredProfesseurs = professeurs.where((prof) {
        return prof.nom.toLowerCase().contains(query.toLowerCase()) ||
            prof.matiereAenseigner.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
      updateDistance(latitude!, longitude!);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Erreur lors de la récupération de la position actuelle : $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      getCurrentLocation();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission de localisation refusée.'),
        ),
      );
    }
  }

  void updateDistance(double userLatitude, double userLongitude) {
    setState(() {
      professeurs.forEach((Professeur) {
        double professeurDistance = Geolocator.distanceBetween(
          userLatitude,
          userLongitude,
          Professeur.latitude,
          Professeur.longitude,
        );
        Professeur.distance = professeurDistance;
      });
      professeurs.sort((a, b) => a.distance.compareTo(b.distance));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "les professeurs les plus proches de vous",
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          itemCount: professeurs.length,
          itemBuilder: (BuildContext context, int index) {
            Professeur professeur = professeurs[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage('$domaine${professeur.imageProfile}'),
                backgroundColor: Colors.grey[200],
              ),
              title: Text(
                professeur.nom,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(professeur.matiereAenseigner),
              trailing: Text(
                '${(professeur.distance / 1000).toStringAsFixed(2)} km',
                style: TextStyle(color: kPrimaryColor),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfesseurDetailPage(professor: professeur),
                  ),
                );
              },
              selected: selectedProfesseur == professeur.id.toString(),
              selectedTileColor: Colors.deepPurple[50],
            );
          },
        ),
      ],
    );
  }
}

class Professeur {
  final int id;
  final String nom;
  final String imageProfile;
  final double latitude;
  final double longitude;
  final String matiereAenseigner;
  final String adresse;
  double distance;

  Professeur({
    required this.id,
    required this.nom,
    required this.imageProfile,
    required this.latitude,
    required this.longitude,
    required this.matiereAenseigner,
    required this.adresse,
    this.distance = 0.0,
  });
}
