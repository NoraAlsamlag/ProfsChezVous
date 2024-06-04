import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_cubit.dart';
import '../../models/user_models.dart';
import '../professeur_ecrans/prof_cours.dart';
import 'components/cours_tab_view.dart';
import 'components/en_tete_accueil.dart';

class AccueilEcrant extends StatelessWidget {
  static String routeName = "/accueil";
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  AccueilEcrant({super.key});

  @override
  Widget build(BuildContext context) {
    User user = context.read<UserCubit>().state;
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              EnTeteAccueil(),
              Expanded(
                child: user.isProfesseur == true
                    ? ProfesseurCoursTabView(scaffoldMessengerKey: scaffoldMessengerKey)
                    : CoursTabView(scaffoldMessengerKey: scaffoldMessengerKey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
