import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:profschezvousfrontend/constants.dart';
import 'package:profschezvousfrontend/ecrans/professeurs_list/professeurs_list_ecrant.dart';
import 'package:profschezvousfrontend/ecrans/accueil/accueil_ecrant.dart';
import 'package:profschezvousfrontend/ecrans/profile/profile_screen.dart';


import 'professeur_ecrans/confirmation_cours.dart';
import '../models/user_cubit.dart';
import '../models/user_models.dart';
import 'notification/notification_ecrant.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  static String routeName = "/";

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  int currentSelectedIndex = 0;

  void updateCurrentIndex(int index) {
    setState(() {
      currentSelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = context.read<UserCubit>().state;

    final pages = [
      const AccueilEcrant(),
      user.isProfesseur == true
        ? const PageConfirmationCours()
        : user.isEleve == true
          ? NotificationEcrant()
          : const ProfesseursListEcrant(),
      const Center(
        child: Text("Discussion"),
      ),
      const ProfileScreen()
    ];

    return Scaffold(
      body: pages[currentSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: updateCurrentIndex,
        currentIndex: currentSelectedIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/home.svg",
              colorFilter: const ColorFilter.mode(
                inActiveIconColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/home.svg",
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              user.isProfesseur == true
                  ? "assets/icons/List.svg"
                  : user.isEleve == true
                    ? "assets/icons/Bell.svg"
                    : "assets/icons/Professeure.svg",
              colorFilter: const ColorFilter.mode(
                inActiveIconColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              user.isProfesseur == true
                  ? "assets/icons/List.svg"
                  : user.isEleve == true
                    ? "assets/icons/Bell.svg"
                    : "assets/icons/Professeure.svg",
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
            label: user.isProfesseur == true
              ? "Cours"
              : user.isEleve == true
                ? "Notifications"
                : "Professeurs",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/Chat bubble Icon.svg",
              colorFilter: const ColorFilter.mode(
                inActiveIconColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/Chat bubble Icon.svg",
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
            label: "Discussion",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/User Icon.svg",
              colorFilter: const ColorFilter.mode(
                inActiveIconColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/User Icon.svg",
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
