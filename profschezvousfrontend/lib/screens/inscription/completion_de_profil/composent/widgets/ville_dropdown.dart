import 'package:flutter/material.dart';
import '../../../../../components/custom_surfix_icon.dart';

class VilleDropdown extends StatefulWidget {
  final Function(String?) onVilleSelected;

  const VilleDropdown({Key? key, required this.onVilleSelected})
      : super(key: key);

  @override
  _VilleDropdownState createState() => _VilleDropdownState();
}

class _VilleDropdownState extends State<VilleDropdown> {
  final List<String> _cities = [
    'Nouakchott',
    'Nouadhibou',
    'Boutilimit',
    'Kaédi',
    'Rosso',
    'Atar',
    'Zouérat',
    'Aleg',
    'Tidjikja',
    'Kiffa',
    'Sélibaby',
    'Néma',
    'Aioun',
    'Akjoujt',
    'Tékane',
    'Bogué',
    'Magta-Lahjar',
    'Aïoun el-Atrouss',
    'Chinguetti',
    'Ouadane',
  ];

  String? _selectedVille;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Ville',
        hintText: 'Sélectionnez votre ville',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
      value: _selectedVille,
      onChanged: (String? newValue) {
        setState(() {
          _selectedVille = newValue;
        });
        widget.onVilleSelected(newValue);
      },
      items: _cities.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez sélectionner une ville';
        }
        return null;
      },
    );
  }
}
