import 'package:flutter/material.dart';
import '../../../../../components/custom_surfix_icon.dart';

class NiveauEtudeDropdown extends StatefulWidget {
  final Function(String?) onNiveauEtudeSelected;

  const NiveauEtudeDropdown({Key? key, required this.onNiveauEtudeSelected})
      : super(key: key);

  @override
  _NiveauEtudeDropdownState createState() => _NiveauEtudeDropdownState();
}

class _NiveauEtudeDropdownState extends State<NiveauEtudeDropdown> {
  final List<String> _niveauxetudes = [
        'Baccalauréat',
        'BTS',
        'DEUG',
        'Licence',
        'Master II',
        'Diplôme d\'ingénieur',
        'Doctorat',
];
   @override
  void initState() {
    super.initState();
    _niveauxetudes.sort();
  }
  String? _selectedNiveauEtude;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'NiveauEtude',
        hintText: 'Sélectionnez votre niveau etude',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/niveauxScolaire.svg"),
      ),
      value: _selectedNiveauEtude,
      onChanged: (String? newValue) {
        setState(() {
          _selectedNiveauEtude = newValue;
        });
        widget.onNiveauEtudeSelected(newValue);
      },
      items: _niveauxetudes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez sélectionner un niveau etude';
        }
        return null;
      },
    );
  }
}
