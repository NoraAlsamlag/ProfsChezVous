import 'package:flutter/widgets.dart';
import 'package:profschezvousfrontend/screens/inscription/page_inscription.dart';
import 'package:profschezvousfrontend/screens/products/products_screen.dart';

import 'screens/inscription/completion_de_profil/ecran_completion_profil.dart';
import 'screens/inscription/inscription_ecrant.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/details/details_screen.dart';
import 'screens/forgot_password/forgot_password_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/init_screen.dart';
import 'screens/login_success/login_success_screen.dart';
import 'screens/profile/profile_type/eleve_compte.dart';
import 'screens/profile/profile_type/prof_compte.dart';
import 'screens/profile/profile_type/parent_compte.dart';
import 'screens/otp/otp_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/splash/splash_screen.dart';
// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  InitScreen.routeName: (context) => const InitScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => const LoginSuccessScreen(),
  InscriptionEcrant.routeName: (context) => const InscriptionEcrant(),
  CompletionProfilEcrant.routeName: (context) => const CompletionProfilEcrant(),
  OtpScreen.routeName: (context) => const OtpScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  ProductsScreen.routeName: (context) => const ProductsScreen(),
  DetailsScreen.routeName: (context) => const DetailsScreen(),
  CartScreen.routeName: (context) => const CartScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  ParentCompte.routeName: (context) => const ParentCompte(),
  ProfCompte.routeName: (context) => const ProfCompte(),
  EleveCompte.routeName: (context) => const EleveCompte(),
  PageInscription.routeName: (context) => const PageInscription(),
};
