import 'package:flutter/material.dart';
import 'package:profschezvousfrontend/ecrans/sign_in/sign_in_screen.dart';
import 'package:profschezvousfrontend/Localisation/utilusateur_localisation.dart';
import 'package:profschezvousfrontend/Localisation/LocationPermissionPrompt.dart';
import '../../../../api/prof/prof_api.dart';
import '../../../../components/custom_surfix_icon.dart';
import '../../../../components/form_error.dart';
import '../../../../constants.dart';
import 'widgets/ecran_envoi_fichiers.dart';
import 'widgets/niveau_etude_dropdown.dart';
import 'widgets/ville_dropdown.dart';
import 'widgets/matiere_a_enseigner_dropdown.dart';

class PageInscriptionProfesseur extends StatefulWidget {
  final String email;
  final String password;

  const PageInscriptionProfesseur({
    required this.email,
    required this.password,
    Key? key,
  }) : super(key: key);

  @override
  _PageInscriptionProfesseurState createState() =>
      _PageInscriptionProfesseurState();
}

class _PageInscriptionProfesseurState extends State<PageInscriptionProfesseur> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? preNom;
  String? nom;
  String? numero_tel;
  String? dateNaissance;
  String? ville;
  String? niveauEtude;
  String? cheminFichierDiplome;
  String? cheminFichierCV;
  List<int> selectedItems = [];
  bool isLoading = false;

  void _updateSelectedItems(List<int> newSelectedItems) {
    setState(() {
      selectedItems = newSelectedItems;
    });
  }

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

  void _handleNiveauEtudeSelected(String? n) {
    setState(() {
      niveauEtude = n;
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

  bool validateForm() {
    bool isValid = true;

    if (preNom == null || preNom!.isEmpty) {
      addError(error: kNamelNullError);
      isValid = false;
    }
    if (preNom!.length < 3) {
      addError(error: kPrenomTropCourtError);
      isValid = false;
    }
    if (preNom!.length > 16) {
      addError(error: kPrenomTropLongError);
      isValid = false;
    }
    if (!nomPrenomValidatorRegExp.hasMatch(preNom!)) {
      addError(error: kPrenomFormatError);
      isValid = false;
    }

    if (nom == null || nom!.isEmpty) {
      addError(error: kNamelNullError);
      isValid = false;
    }
    if (nom!.length < 3) {
      addError(error: kNomeTropCourtError);
      isValid = false;
    }
    if (nom!.length > 16) {
      addError(error: kNomeTropLongError);
      isValid = false;
    }
    if (!nomPrenomValidatorRegExp.hasMatch(nom!)) {
      addError(error: kNomeFormatError);
      isValid = false;
    }

    if (numero_tel == null || numero_tel!.isEmpty) {
      addError(error: kPhoneNumberNullError);
      isValid = false;
    }
    if (!numeroTelephoneValidatorRegExp.hasMatch(numero_tel!)) {
      addError(error: kNumeroTelephoneCommencerPar234);
      isValid = false;
    }
    if (numero_tel!.length != 8) {
      addError(error: kNumeroTelephoneLengthError);
      isValid = false;
    }
    if (!numeroTelephoneContientLetterValidatorRegExp.hasMatch(numero_tel!)) {
      addError(error: kNumeroTelephoneContientLetterError);
      isValid = false;
    }

    if (dateNaissance == null || dateNaissance!.isEmpty) {
      addError(error: 'Veuillez sélectionner une date de naissance');
      isValid = false;
    }
    if (validateDateNaissance(dateNaissance) != null) {
      isValid = false;
    }

    if (ville == null || ville!.isEmpty) {
      addError(error: 'Veuillez sélectionner une ville');
      isValid = false;
    }

    if (niveauEtude == null || niveauEtude!.isEmpty) {
      addError(error: 'Veuillez sélectionner un niveau d\'étude');
      isValid = false;
    }

    if (selectedItems.isEmpty) {
      addError(error: 'Veuillez sélectionner au moins une matière.');
      isValid = false;
    }

    if (cheminFichierCV == null || cheminFichierCV!.isEmpty) {
      addError(error: 'Veuillez choisir un fichier CV.');
      isValid = false;
    }

    if (cheminFichierDiplome == null || cheminFichierDiplome!.isEmpty) {
      addError(error: 'Veuillez choisir un fichier Diplôme.');
      isValid = false;
    }

    return isValid;
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
                removeError(error: kPrenomTropCourtError);
                removeError(error: kPrenomTropLongError);
                removeError(error: kPrenomFormatError);
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
                removeError(error: kNomeTropCourtError);
                removeError(error: kNomeTropLongError);
                removeError(error: kNomeFormatError);
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
                addError(error: kNumeroTelephoneCommencerPar234);
              }
              if (value.length == 8) {
                removeError(error: kNumeroTelephoneLengthError);
              }
              if (numeroTelephoneContientLetterValidatorRegExp
                  .hasMatch(value)) {
                removeError(error: kNumeroTelephoneContientLetterError);
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
          NiveauEtudeDropdown(
            onNiveauEtudeSelected: _handleNiveauEtudeSelected,
          ),
          const SizedBox(height: 20),
          MatiereAEnseigneeDropdown(
            onSelectionChanged: (selectedMatieres) {
              setState(() {
                selectedItems = selectedMatieres;
              });
            },
          ),
          const SizedBox(height: 20),
          EcranEnvoiFichiers(
            onCheminFichierCV: (cheminCV) {
              setState(() {
                cheminFichierCV = cheminCV;
              });
            },
            onCheminFichierDiplome: (cheminDiplome) {
              setState(() {
                cheminFichierDiplome = cheminDiplome;
              });
            },
          ),
          const SizedBox(height: 16.0),
          Text(cheminFichierCV?.isNotEmpty == true
              ? 'Fichier CV : ${cheminFichierCV!}'
              : 'Veuillez choisir un fichier CV.'),
          const SizedBox(height: 16.0),
          Text(cheminFichierDiplome?.isNotEmpty == true
              ? 'Fichier Diplôme : ${cheminFichierDiplome!}'
              : 'Veuillez choisir un fichier Diplôme.'),
          const SizedBox(height: 20),
          FormError(errors: errors),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              print(selectedItems.toString());
              if (_formKey.currentState!.validate() && validateForm()) {
                setState(() {
                  isLoading = true;
                });
                bool permissionGranted =
                    await requestLocationPermission(context);
                if (permissionGranted) {
                  Map<String, double>? locationData =
                      await getCurrentLocation();
                  if (locationData != null) {
                    enregistrerProfesseur(
                      email: widget.email,
                      motDePasse: widget.password,
                      nom: nom!,
                      prenom: preNom!,
                      dateNaissance: dateNaissance!,
                      ville: ville!,
                      longitude: locationData['longitude'].toString(),
                      latitude: locationData['latitude'].toString(),
                      numeroTelephone: numero_tel!,
                      matieresAEnseigner: selectedItems,
                      niveauEtude: niveauEtude!,
                      cvPath: cheminFichierCV!,
                      diplomePath: cheminFichierDiplome!,
                    ).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Inscription réussie. Vous pouvez maintenant vous connecter.'),
                          duration: Duration(seconds: 2),
                        ),
                      );

                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.pushReplacementNamed(
                            context, SignInScreen.routeName);
                      });
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Échec de l\'enregistrement. Veuillez réessayer.: $error'),
                        ),
                      );
                    }).whenComplete(() {
                      setState(() {
                        isLoading = false;
                      });
                    });
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Impossible d\'obtenir les données de localisation.'),
                      ),
                    );
                  }
                } else {
                  setState(() {
                    isLoading = false;
                  });
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
            visible: isLoading,
            child: const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
