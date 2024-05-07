import 'package:flutter/material.dart';
import 'package:profschezvousfrontend/api/parent/parent_api.dart';
import 'package:profschezvousfrontend/screens/sign_in/sign_in_screen.dart';
import 'package:profschezvousfrontend/Localisation/utilusateur_localisation.dart';
import 'package:profschezvousfrontend/Localisation/LocationPermissionPrompt.dart';
import '../../../../components/custom_surfix_icon.dart';
import '../../../../components/form_error.dart';
import '../../../../constants.dart';
import 'widgets/ville_dropdown.dart';

class PageInscriptionParent extends StatefulWidget {
  final String email;
  final String password;

  const PageInscriptionParent({
    required this.email,
    required this.password,
    Key? key,
  }) : super(key: key);

  @override
  _PageInscriptionParentState createState() => _PageInscriptionParentState();
}

class _PageInscriptionParentState extends State<PageInscriptionParent> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? preNom;
  String? nom;
  String? numero_tel;
  String? dateNaissance;
  String? ville;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  void _handleVilleSelected(String? v) {
    setState(() {
      ville = v;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());

    if (_picked != null) {
      setState(() {
        dateNaissance = _picked.toString().split(" ")[0];
      });
    }
  }

  String? validateDateNaissance(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez sélectionner une date de naissance';
    }

    final selectedDateTime = DateTime.parse(value);
    final minimumAge = DateTime.now().subtract(Duration(days: 18 * 365));
    if (selectedDateTime.isAfter(minimumAge)) {
      return 'Vous devez avoir au moins 18 ans.';
    }

    return null;
  }

  Future<void> _requestLocationPermission() async {
    bool permissionGranted = await requestLocationPermission(context);
    if (!permissionGranted) {
      // Handle the case when location permission is denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission de localisation refusée.'),
        ),
      );
    }
  }

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            onSaved: (newValue) => preNom = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kNamelNullError);
              } else if (value.length > 16) {
                removeError(error: kPrenomTropLongError);
              }
              preNom = value;
              if (value.length >= 3 &&
                  value.length <= 16 &&
                  nomPrenomValidatorRegExp.hasMatch(value)) {
                removeError(error: kPrenomFormatError);
              } else {
                removeError(
                    error:
                        kPrenomTropCourtError); // Supprimer l'erreur si le prénom est valide
                removeError(
                    error:
                        kPrenomTropLongError); // Supprimer l'erreur si le prénom est valide
                removeError(
                    error:
                        kPrenomFormatError); // Supprimer l'erreur si le prénom est valide
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              } else if (value.length < 3) {
                addError(error: kPrenomTropCourtError);
                return kPrenomTropCourtError;
              } else if (value.length > 16) {
                addError(error: kPrenomTropLongError);
                return kPrenomTropLongError;
              } else if (!nomPrenomValidatorRegExp.hasMatch(value)) {
                addError(error: kPrenomFormatError);
                return kPrenomFormatError;
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Prénom",
              hintText: "Entrez votre prénom",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            onSaved: (newValue) => nom = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kNamelNullError);
              } else if (value.length > 16) {
                removeError(error: kNomeTropLongError);
              }
              nom = value;
              if (value.length >= 3 &&
                  value.length <= 16 &&
                  nomPrenomValidatorRegExp.hasMatch(value)) {
                removeError(error: kNomeFormatError);
              } else {
                removeError(
                    error:
                        kNomeTropCourtError); // Supprimer l'erreur si le nom est valide
                removeError(
                    error:
                        kNomeTropLongError); // Supprimer l'erreur si le nom est valide
                removeError(
                    error:
                        kNomeFormatError); // Supprimer l'erreur si le nom est valide
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              } else if (value.length < 3) {
                addError(error: kNomeTropCourtError);
                return kNomeTropCourtError;
              } else if (value.length > 16) {
                addError(error: kNomeTropLongError);
                return kNomeTropLongError;
              } else if (!nomPrenomValidatorRegExp.hasMatch(value)) {
                addError(error: kNomeFormatError);
                return kNomeFormatError;
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Nom de famille",
              hintText: "Entrez votre nom de famille",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.phone,
            onSaved: (newValue) => numero_tel = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPhoneNumberNullError);
              }
              numero_tel = value;
              if (numeroTelephoneValidatorRegExp.hasMatch(value)) {
                removeError(error: kNumeroTelephoneCommencerPar234);
              } else {
                addError(
                    error:
                        kNumeroTelephoneCommencerPar234); // Ajoutez l'erreur si le numéro ne commence pas par 2, 3 ou 4
              }
              if (value.length == 8) {
                removeError(
                    error:
                        kNumeroTelephoneLengthError); // Supprimez l'erreur si la longueur est égale à 8 chiffres
              }
              if (numeroTelephoneContientLetterValidatorRegExp
                  .hasMatch(value)) {
                removeError(
                    error:
                        kNumeroTelephoneContientLetterError); // Supprimez l'erreur si le numéro ne contient pas de lettres
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPhoneNumberNullError);
                return "";
              } else if (!numeroTelephoneValidatorRegExp.hasMatch(value)) {
                addError(error: kNumeroTelephoneCommencerPar234);
                return kNumeroTelephoneCommencerPar234;
              } else if (value.length != 8) {
                addError(error: kNumeroTelephoneLengthError);
                return kNumeroTelephoneLengthError;
              } else if (!numeroTelephoneContientLetterValidatorRegExp
                  .hasMatch(value)) {
                addError(error: kNumeroTelephoneContientLetterError);
                return kNumeroTelephoneContientLetterError;
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Numéro de téléphone",
              hintText: "Entrez votre numéro de téléphone",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
            ),
          ),
          const SizedBox(height: 20),
          VilleDropdown(
            onVilleSelected: _handleVilleSelected,
          ),
          const SizedBox(height: 20),
          TextFormField(
            onTap: () {
              _selectDate(context);
            },
            readOnly: true,
            controller: TextEditingController(
              text: dateNaissance != null ? dateNaissance : '',
            ),
            decoration: const InputDecoration(
              labelText: "Date de naissance",
              hintText: "Sélectionnez votre date de naissance",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  CustomSurffixIcon(svgIcon: "assets/icons/calendar.svg"),
            ),
            validator: validateDateNaissance,
          ),
          const SizedBox(height: 20),
          FormError(errors: errors),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  isLoading =
                      true; // Définit isLoading à true avant l'appel à enregistrerProfesseur
                });
                bool permissionGranted =
                    await requestLocationPermission(context);
                if (permissionGranted) {
                  Map<String, double>? locationData =
                      await getCurrentLocation();
                  if (locationData != null) {
                    if (preNom != null &&
                        nom != null &&
                        dateNaissance != null &&
                        numero_tel != null) {
                      enregistrerParent(
                        email: widget.email,
                        motDePasse: widget.password,
                        nom: nom!,
                        prenom: preNom!,
                        dateNaissance: dateNaissance!,
                        ville: ville!,
                        longitude: locationData['longitude'].toString(),
                        latitude: locationData['latitude'].toString(),
                        numeroTelephone: numero_tel!,
                        quartierResidence: 'QuartierParent',
                      ).then((_) {
                        // Afficher un message de succès
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Inscription réussie. Vous pouvez maintenant vous connecter.'),
                            duration: Duration(seconds: 2),
                          ),
                        );

                        // Naviguer vers la page de connexion après un délai
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.pushReplacementNamed(
                              context, SignInScreen.routeName);
                        });
                      }).catchError((error) {
                        // Afficher un message d'erreur en cas d'échec de l'inscription
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Échec de l\'enregistrement. Veuillez réessayer.: $error'),
                          ),
                        );
                      }).whenComplete(() {
                        setState(() {
                          isLoading =
                              false; // Définit isLoading à false après l'appel à enregistrerProfesseur
                        });
                      });
                    } else {
                      // Afficher un message d'erreur si des champs requis sont manquants
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Veuillez remplir tous les champs requis.'),
                        ),
                      );
                    }
                  } else {
                    // Location data not obtained, show an error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Impossible d\'obtenir les données de localisation.'),
                      ),
                    );
                  }
                } else {
                  // Location permission was denied, handle accordingly
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Permission de localisation refusée.'),
                    ),
                  );
                }
              }
            },
            child: const Text("Continue"),
          ),
          Visibility(
            visible:
                isLoading, // Contrôle la visibilité de l'indicateur de chargement
            child:
                CircularProgressIndicator(), // Indicateur de chargement circulaire
          ),
        ],
      ),
    );
  }
}
