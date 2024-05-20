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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
  }

  void updateSearchQuery(String query) {
    if (mounted) {
      setState(() {
        final searchLower = query.toLowerCase();
        filteredProfesseurs = professeurs.where((prof) {
          final nameLower = prof.nom.toLowerCase();
          final subjectsLower = prof.matieresAenseigner.join(' ').toLowerCase();
          return nameLower.contains(searchLower) || subjectsLower.contains(searchLower);
        }).toList();

        // Reorder the subjects to prioritize the searched matiere
        filteredProfesseurs.forEach((prof) {
          if (prof.matieresAenseigner.any((matiere) => matiere.toLowerCase().contains(searchLower))) {
            prof.matieresAenseigner.sort((a, b) {
              if (a.toLowerCase().contains(searchLower)) return -1;
              if (b.toLowerCase().contains(searchLower)) return 1;
              return 0;
            });
          }
        });
      });
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (mounted) {
        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
        });
        await obtenirProfesseursEtCalculerDistances(
            position.latitude, position.longitude);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Erreur lors de la récupération de la position actuelle : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      getCurrentLocation();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permission de localisation refusée.'),
          ),
        );
      }
    }
  }

  Future<void> obtenirProfesseursEtCalculerDistances(
      double userLatitude, double userLongitude) async {
    try {
      List<dynamic> professeursData = await obtenirProfesseurs();
      if (mounted) {
        setState(() {
          professeurs = professeursData.map((item) {
            return Professeur(
              id: item['user_id'],
              nom: '${item['prenom']} ${item['nom']}',
              latitude: item['latitude'],
              longitude: item['longitude'],
              matieresAenseigner: item['matieres_a_enseigner'],
              adresse: item['adresse'],
              imageProfile: item['image_profil'] ?? userDefaultImage,
            );
          }).toList();

          // Calculer les distances
          professeurs.forEach((prof) {
            double professeurDistance = Geolocator.distanceBetween(
              userLatitude,
              userLongitude,
              prof.latitude,
              prof.longitude,
            );
            prof.distance = professeurDistance;
          });

          // Trier par distance
          professeurs.sort((a, b) => a.distance.compareTo(b.distance));
          filteredProfesseurs = List<Professeur>.from(professeurs);
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération des professeurs : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Rechercher',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onChanged: updateSearchQuery,
          ),
        ),
        SizedBox(height: 10),
        isLoading
            ? Center(child: CircularProgressIndicator())
            : Expanded(
                child: ListView.builder(
                  itemCount: filteredProfesseurs.length,
                  itemBuilder: (BuildContext context, int index) {
                    Professeur professeur = filteredProfesseurs[index];

                    // Create the subtitle text based on the number of subjects
                    String subtitleText;
                    if (professeur.matieresAenseigner.length > 2) {
                      subtitleText = professeur.matieresAenseigner
                              .take(2)
                              .join(', ') +
                          ' et ${professeur.matieresAenseigner.length - 2} autre(s))';
                    } else {
                      subtitleText = professeur.matieresAenseigner.join(', ');
                    }

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
                      subtitle: Text(subtitleText),
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
  final List<dynamic> matieresAenseigner;
  final String adresse;
  double distance;

  Professeur({
    required this.id,
    required this.nom,
    required this.imageProfile,
    required this.latitude,
    required this.longitude,
    required this.matieresAenseigner,
    required this.adresse,
    this.distance = 0.0,
  });
}
