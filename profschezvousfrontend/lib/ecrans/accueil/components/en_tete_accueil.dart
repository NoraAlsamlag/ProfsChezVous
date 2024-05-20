import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../api/notification/notification_api.dart';
import '../../../models/user_models.dart';
import '../../parent_ecrans/cours_reserves_page.dart';
import '../../notification/notification_ecrant.dart';
import 'icon_btn_avec_compteur.dart';
import 'champ_recherche.dart';
import '../../../models/user_cubit.dart';

class EnTeteAccueil extends StatefulWidget {
  const EnTeteAccueil({Key? key}) : super(key: key);

  @override
  _EnTeteAccueilState createState() => _EnTeteAccueilState();
}

class _EnTeteAccueilState extends State<EnTeteAccueil> {
  int _nombreNotificationsNonLues = 0;

  @override
  void initState() {
    super.initState();
    _chargerNombreNotificationsNonLues();
  }

  Future<void> _chargerNombreNotificationsNonLues() async {
    try {
      int count = await fetchNombreNotificationsNonLues();
      setState(() {
        _nombreNotificationsNonLues = count;
      });
    } catch (e) {
      print('Échec de la récupération du nombre de notifications non lues: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = context.read<UserCubit>().state;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(child: ChampRecherche()),
          const SizedBox(width: 16),
          if (user.isParent == true)
            IconBtnAvecCompteur(
              svgSrc: "assets/icons/List.svg",
              press: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PageCoursReserves(),
                ),
              ),
            ),
          const SizedBox(width: 8),
          IconBtnAvecCompteur(
            svgSrc: "assets/icons/Bell.svg",
            numOfitem: _nombreNotificationsNonLues,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationEcrant(),
                ),
              ).then((_) => _chargerNombreNotificationsNonLues()); // Refresh the count after returning
            },
          ),
        ],
      ),
    );
  }
}
