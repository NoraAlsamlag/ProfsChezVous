import 'package:flutter/material.dart';

class NiveauScolaireDropdown extends StatefulWidget {
  final Function(String?) onNiveauScolaireSelected;

  const NiveauScolaireDropdown({Key? key, required this.onNiveauScolaireSelected})
      : super(key: key);

  @override
  _NiveauScolaireDropdownState createState() => _NiveauScolaireDropdownState();
}

class _NiveauScolaireDropdownState extends State<NiveauScolaireDropdown> {
  final List<String> _niveauxScolaires = [
  '1ère Année Fondamentale',
  '2ème Année Fondamentale',
  '3ème Année Fondamentale',
  '4ème Année Fondamentale',
  '5ème Année Fondamentale',
  '6ème Année Fondamentale',
  '1ère Année Secondaire',
  '2ème Année Secondaire',
  '3ème Année Secondaire',
  '4ème Année Secondaire',
  '5ème Année Lycée',
  '6ème Année Lycée',
  '7ème Année Lycée',
];
   @override
  void initState() {
    super.initState();
    _niveauxScolaires.sort();
  }
  String? _selectedNiveauScolaire;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'NiveauScolaire',
        hintText: 'Sélectionnez niveau scolaire',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/niveauxScolaire.svg"),
      ),
      value: _selectedNiveauScolaire,
      onChanged: (String? newValue) {
        setState(() {
          _selectedNiveauScolaire = newValue;
        });
        widget.onNiveauScolaireSelected(newValue);
      },
      items: _niveauxScolaires.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez sélectionner un niveau scolaire';
        }
        return null;
      },
    );
  }
}
