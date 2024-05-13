import 'package:flutter/material.dart';

import '../../../../../components/custom_surfix_icon.dart';
import 'niveau_scolaire_dropdown.dart';

class EnfantForm extends StatefulWidget {
  final Function(String, String, String?, String?, String) onEnfantForm;

  EnfantForm({required this.onEnfantForm});

  @override
  _EnfantFormState createState() => _EnfantFormState();
}

class _EnfantFormState extends State<EnfantForm> {
  final _formKey = GlobalKey<FormState>();

  String _prenom = '';
  String _nom = '';
  String? _dateNaissance;
  String? _niveauScolaire;
  String _etablissement = '';
  
  Future<void> _selectDate(BuildContext context) async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());

    if (_picked != null) {
      setState(() {
        _dateNaissance = _picked.toString().split(" ")[0];
      });
    }
  }


  String? validateDateNaissance(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez sélectionner une date de naissance';
    }

    final selectedDateTime = DateTime.parse(value);
    final minimumAge = DateTime.now().subtract(Duration(days: 5 * 365));
    if (selectedDateTime.isAfter(minimumAge)) {
      return 'Vous devez avoir au moins 5 ans.';
    }

    return null;
  }

  void _handleNiveauScolaireSelected(String? n) {
    setState(() {
      _niveauScolaire = n;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Prénom'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un prénom';
              }
              return null;
            },
            onSaved: (value) {
              _prenom = value!;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(labelText: 'Nom'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un nom';
              }
              return null;
            },
            onSaved: (value) {
              _nom = value!;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            onTap: () {
              _selectDate(context);
            },
            readOnly: true,
            controller: TextEditingController(
              text: _dateNaissance != null ? _dateNaissance : '',
            ),
            decoration: const InputDecoration(
              labelText: "Date de naissance",
              hintText: "aaaa-mm-jj",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  CustomSurffixIcon(svgIcon: "assets/icons/calendar.svg"),
            ),
            validator: validateDateNaissance,
          ),
          const SizedBox(height: 20),
          NiveauScolaireDropdown(
            onNiveauScolaireSelected: _handleNiveauScolaireSelected,
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(labelText: 'Établissement'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un établissement';
              }
              return null;
            },
            onSaved: (value) {
              _etablissement = value!;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.onEnfantForm(
                  _prenom,
                  _nom,
                  _dateNaissance,
                  _niveauScolaire,
                  _etablissement,
                );
                Navigator.of(context).pop();
              }
            },
            child: Text('Soumettre'),
          ),
        ],
      ),
    );
  }
}