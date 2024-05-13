import 'package:flutter/material.dart';
import 'components/categories.dart';
import 'components/discount_banner.dart';
import 'components/home_header.dart';

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
              HomeHeader(),
              DiscountBanner(),
              Categories(),
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
