import 'package:flutter/material.dart';

import '../../../api/utilisateur/utilisateur_api.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../completion_de_profil/ecran_completion_profil.dart';

class InscriptionForm extends StatefulWidget {
  final String type;

  const InscriptionForm({Key? key, required this.type}) : super(key: key);

  @override
  _InscriptionFormState createState() => _InscriptionFormState();
}

class _InscriptionFormState extends State<InscriptionForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? conform_password;
  bool remember = false;
  final List<String?> errors = [];

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
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) async {
              if (value.isNotEmpty) {
                removeError(error: kEmailNullError);
              } else if (emailValidatorRegExp.hasMatch(value)) {
                removeError(error: kInvalidEmailError);
              }
              // Vérifier l'email uniquement si le format est correct
              if (emailValidatorRegExp.hasMatch(value)) {
                bool emailExiste = await verifierEmail(value);
                if (emailExiste) {
                  addError(error: kEmailDejaUtiliseError);
                } else {
                  removeError(error: kEmailDejaUtiliseError);
                }
              }
              email = value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kEmailNullError);
                return "";
              } else if (!emailValidatorRegExp.hasMatch(value)) {
                addError(error: kInvalidEmailError);
                return "";
              } else if (errors.contains(kEmailDejaUtiliseError)) {
                return kEmailDejaUtiliseError;
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "E-mail",
              hintText: "Entrez votre adresse e-mail",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            onSaved: (newValue) => password = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              } else if (value.length >= 8) {
                removeError(error: kShortPassError);
              }
              password = value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError);
                return "";
              } else if (value.length < 8) {
                addError(error: kShortPassError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Mot de passe",
              hintText: "Entrez votre mot de passe",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            onSaved: (newValue) => conform_password = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              } else if (value.isNotEmpty && password == conform_password) {
                removeError(error: kMatchPassError);
              }
              conform_password = value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError);
                return "";
              } else if ((password != value)) {
                addError(error: kMatchPassError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Confirmer le mot de passe",
              hintText: "Ré-entrez votre mot de passe",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
          ),
          FormError(errors: errors),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // if all are valid then go to success screen
                Navigator.pushNamed(
                  context,
                  CompletionProfilEcrant.routeName,
                  arguments: {
                    'type': widget.type,
                    'email': email,
                    'password': password,
                  },
                );
              }
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}
