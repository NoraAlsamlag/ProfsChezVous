// import 'package:flutter/material.dart';
// import 'package:profschezvousfrontend/api/parent/parent_api.dart';
// import 'package:profschezvousfrontend/screens/sign_in/sign_in_screen.dart';
// import 'package:profschezvousfrontend/Localisation/utilusateur_localisation.dart';
// import 'package:profschezvousfrontend/Localisation/LocationPermissionPrompt.dart';
// import '../../../components/custom_surfix_icon.dart';
// import '../../../components/form_error.dart';
// import '../../../constants.dart';
// import '../../otp/otp_screen.dart';
// import 'package:geolocator/geolocator.dart';

// class CompleteProfileForm extends StatefulWidget {
//   final String email;
//   final String password;

//   const CompleteProfileForm({
//     required this.email,
//     required this.password,
//     Key? key,
//   }) : super(key: key);

//   @override
//   _CompleteProfileFormState createState() => _CompleteProfileFormState();
// }

// class _CompleteProfileFormState extends State<CompleteProfileForm> {
//   final _formKey = GlobalKey<FormState>();
//   final List<String?> errors = [];
//   String? preNom;
//   String? nom;
//   String? numero_tel;
//   String? address;

//   @override
//   void initState() {
//     super.initState();
//     _requestLocationPermission();
//   }

//   Future<void> _requestLocationPermission() async {
//     bool permissionGranted = await requestLocationPermission(context);
//     if (!permissionGranted) {
//       // Handle the case when location permission is denied
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Permission de localisation refusée.'),
//         ),
//       );
//     }
//   }

//   void addError({String? error}) {
//     if (!errors.contains(error)) {
//       setState(() {
//         errors.add(error);
//       });
//     }
//   }

//   void removeError({String? error}) {
//     if (errors.contains(error)) {
//       setState(() {
//         errors.remove(error);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           TextFormField(
//             onSaved: (newValue) => preNom = newValue,
//             onChanged: (value) {
//               if (value.isNotEmpty) {
//                 removeError(error: kNamelNullError);
//               } else if (value.length > 16) {
//                 removeError(error: kNamelNullError);
//               }
//               preNom = value;
//             },
//             validator: (value) {
//               if (value!.isEmpty) {
//                 addError(error: kNamelNullError);
//                 return "";
//               } else if (value.length < 3) {
//                 addError(error: kNamelNullError);
//                 return "";
//               }
//               return null;
//             },
//             decoration: const InputDecoration(
//               labelText: "Prénom",
//               hintText: "Entrez votre prénom",
//               floatingLabelBehavior: FloatingLabelBehavior.always,
//               suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
//             ),
//           ),
//           const SizedBox(height: 20),
//           TextFormField(
//             onSaved: (newValue) => nom = newValue,
//             onChanged: (value) {
//               if (value.isNotEmpty) {
//                 removeError(error: kNamelNullError);
//               } else if (value.length > 16) {
//                 removeError(error: kNamelNullError);
//               }
//               nom = value;
//             },
//             validator: (value) {
//               if (value!.isEmpty) {
//                 addError(error: kNamelNullError);
//                 return "";
//               } else if (value.length < 3) {
//                 addError(error: kNamelNullError);
//                 return "";
//               }
//               return null;
//             },
//             decoration: const InputDecoration(
//               labelText: "Nom de famille",
//               hintText: "Entrez votre nom de famille",
//               floatingLabelBehavior: FloatingLabelBehavior.always,
//               suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
//             ),
//           ),
//           const SizedBox(height: 20),
//           TextFormField(
//             keyboardType: TextInputType.phone,
//             onSaved: (newValue) => numero_tel = newValue,
//             onChanged: (value) {
//               if (value.isNotEmpty) {
//                 removeError(error: kPhoneNumberNullError);
//               }
//               numero_tel = value;
//             },
//             validator: (value) {
//               if (value!.isEmpty) {
//                 addError(error: kPhoneNumberNullError);
//                 return "";
//               }
//               return null;
//             },
//             decoration: const InputDecoration(
//               labelText: "Numéro de téléphone",
//               hintText: "Entrez votre numéro de téléphone",
//               floatingLabelBehavior: FloatingLabelBehavior.always,
//               suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
//             ),
//           ),
//           const SizedBox(height: 20),
//           TextFormField(
//             onSaved: (newValue) => address = newValue,
//             onChanged: (value) {
//               if (value.isNotEmpty) {
//                 removeError(error: kAddressNullError);
//               }
//               address = value;
//             },
//             validator: (value) {
//               if (value!.isEmpty) {
//                 addError(error: kAddressNullError);
//                 return "";
//               }
//               return null;
//             },
//             decoration: const InputDecoration(
//               labelText: "Adresse",
//               hintText: "Entrez votre adresse",
//               floatingLabelBehavior: FloatingLabelBehavior.always,
//               suffixIcon:
//                   CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
//             ),
//           ),
//           FormError(errors: errors),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () async {
//               if (_formKey.currentState!.validate()) {
//                 bool permissionGranted =
//                     await requestLocationPermission(context);
//                 if (permissionGranted) {
//                   Map<String, double>? locationData =
//                       await getCurrentLocation();
//                   if (locationData != null) {
//                     if (preNom != null &&
//                         nom != null &&
//                         address != null &&
//                         numero_tel != null) {
//                       registerParent(
//                         email: widget.email,
//                         password: widget.password,
//                         nom: nom!,
//                         prenom: preNom!,
//                         dateNaissance: '2000-01-01',
//                         ville: 'VilleParent',
//                         adresse: address!,
//                         longitude: locationData['longitude'].toString(),
//                         latitude: locationData['latitude'].toString(),
//                         numeroTelephone: numero_tel!,
//                         quartierResidence: 'QuartierParent',
//                       ).then((_) {
//                         // Afficher un message de succès
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text(
//                                 'Inscription réussie. Vous pouvez maintenant vous connecter.'),
//                             duration: Duration(seconds: 2),
//                           ),
//                         );

//                         // Naviguer vers la page de connexion après un délai
//                         Future.delayed(Duration(seconds: 2), () {
//                           Navigator.pushReplacementNamed(
//                               context, SignInScreen.routeName);
//                         });
//                       }).catchError((error) {
//                         // Afficher un message d'erreur en cas d'échec de l'inscription
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                                 'Échec de l\'enregistrement. Veuillez réessayer.: $error'),
//                           ),
//                         );
//                       });
//                     } else {
//                       // Afficher un message d'erreur si des champs requis sont manquants
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content:
//                               Text('Veuillez remplir tous les champs requis.'),
//                         ),
//                       );
//                     }
//                   } else {
//                     // Location data not obtained, show an error message
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text(
//                             'Impossible d\'obtenir les données de localisation.'),
//                       ),
//                     );
//                   }
//                 } else {
//                   // Location permission was denied, handle accordingly
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Permission de localisation refusée.'),
//                     ),
//                   );
//                 }
//               }
//             },
//             child: const Text("Continue"),
//           ),
//         ],
//       ),
//     );
//   }
// }
