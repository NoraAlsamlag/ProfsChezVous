import 'package:flutter/material.dart';

class CoursUniteReservationPage extends StatelessWidget {
  final int professeurId;

  const CoursUniteReservationPage({Key? key, required this.professeurId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réserver un Cours Unitaire'),
      ),
      body: Center(
        child: Text('Page de réservation de cours unitaire pour le professeur $professeurId'),
      ),
    );
  }
}
