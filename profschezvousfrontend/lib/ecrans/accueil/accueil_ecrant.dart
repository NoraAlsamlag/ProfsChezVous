import 'package:flutter/material.dart';
import 'components/en_tete_accueil.dart';

class AccueilEcrant extends StatelessWidget {
  static String routeName = "/accueil";

  const AccueilEcrant({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              EnTeteAccueil(),
              // DiscountBanner(),
              // Categories(),
              // CourseReservationWidget(),
              // SpecialOffers(),
              // SizedBox(height: 20),
              // PopularProducts(),
              // SizedBox(height: 20),
              // Text("acceil"),
            ],
          ),
        ),
      ),
    );
  }
}
