import 'package:flutter/material.dart';

const tokenBox = "ProfsChezVousTOKEN";

const domaine = 'http://10.0.2.2:8000';

const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Colors.black;

const kAnimationDuration = Duration(milliseconds: 200);

const headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp numeroTelephoneValidatorRegExp = RegExp(r"^[2-4]");
final RegExp numeroTelephoneContientLetterValidatorRegExp = RegExp(r'^[0-9]+$');
final RegExp nomPrenomValidatorRegExp = RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$");

const String kNumeroTelephoneCommencerPar234 = "Le numéro de téléphone doit commencer par 2, 3 ou 4";
const String kEmailNullError = "Veuillez entrer votre e-mail";
const String kInvalidEmailError = "Veuillez entrer une adresse e-mail valide";
const String kPassNullError = "Veuillez entrer votre mot de passe";
const String kShortPassError = "Le mot de passe est trop court";
const String kMatchPassError = "Les mots de passe ne correspondent pas";
const String kNamelNullError = "Veuillez entrer votre nom";
const String kPhoneNumberNullError = "Veuillez entrer votre numéro de téléphone";
const String kAddressNullError = "Veuillez entrer votre adresse";
const String kDateNaissanceNullError = "Veuillez entrer votre date de naissance";
const String kEtablissementNullError = "Veuillez entrer le nom de l'établissement";
const String kEmailDejaUtiliseError = "Cet email est déjà utilisé";
const String kNumeroTelephoneContientLetterError = "Le numéro de téléphone ne doit contenir que des chiffres";
const String kNumeroTelephoneLengthError = "Le numéro de téléphone ne doit pas dépasser 8 chiffres";
const String kNomeTropLongError = "Le nom de famille est trop long";
const String kPrenomTropLongError = "Le prénom est trop long";
const String kNomeFormatError = "Le nom de famille n'est pas valide";
const String kPrenomFormatError = "Le prénom n'est pas valide";
const String kPrenomTropCourtError = "Le prénom est trop court";
const String kNomeTropCourtError = "Le nom de famille est trop court";


final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 16),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: kTextColor),
  );
}
