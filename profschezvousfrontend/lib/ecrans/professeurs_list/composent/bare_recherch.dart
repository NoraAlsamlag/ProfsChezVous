// import 'package:flutter/material.dart';

// import 'professeurs_list.dart';

// class CustomSearchDelegate extends SearchDelegate {
//   final List<Professeur> professeurs;
//   final Function(List<Professeur>) updateFilteredProfesseurs;

//   CustomSearchDelegate({required this.professeurs, required this.updateFilteredProfesseurs});

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//           showSuggestions(context);
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     List<Professeur> results = professeurs.where((prof) {
//       return prof.nom.toLowerCase().contains(query.toLowerCase()) ||
//              prof.matiereAenseigner.toLowerCase().contains(query.toLowerCase());
//     }).toList();
//     updateFilteredProfesseurs(results);
//     return ListView(
//       children: results.map((prof) => ListTile(
//         title: Text(prof.nom),
//         subtitle: Text(prof.matiereAenseigner),
//         onTap: () {
//           // Here you could navigate to the detail page or perform other actions
//           close(context, prof);
//         },
//       )).toList(),
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<Professeur> suggestions = professeurs.where((prof) {
//       return prof.nom.toLowerCase().contains(query.toLowerCase()) ||
//              prof.matiereAenseigner.toLowerCase().contains(query.toLowerCase());
//     }).toList();
//     return ListView(
//       children: suggestions.map((prof) => ListTile(
//         title: Text(prof.nom),
//         subtitle: Text(prof.matiereAenseigner),
//         onTap: () {
//           query = prof.nom;
//           showResults(context);
//         },
//       )).toList(),
//     );
//   }
// }
