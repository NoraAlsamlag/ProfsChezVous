import 'package:flutter/material.dart';
import '../../../../../components/form_error.dart';
import 'multi_select.dart';

class MatiereAEnseigneeDropdown extends StatefulWidget {
  // final List<String> selectedItems;
  final ValueChanged<List<String>> onSelectionChanged;

  const MatiereAEnseigneeDropdown({
    Key? key,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _MatiereAEnseigneeDropdownState createState() =>
      _MatiereAEnseigneeDropdownState();
}

class _MatiereAEnseigneeDropdownState extends State<MatiereAEnseigneeDropdown> {
  Map<String, List<String>> categories = {
  'Mathématiques': ['Algèbre', 'Géométrie', 'Calcul'],
  'Sciences': ['Physique', 'Chimie', 'Biologie'],
  'Histoire': ['Ancienne', 'Moderne', 'Contemporaine'],
  'Géographie': ['Physique', 'Humaine', 'Économique'],
  'Langues': ['Français', 'Anglais', 'Espagnol'],
  'Informatique': ['Programmation', 'Réseaux', 'Bases de données'],
};
  // List<String> selectedItems = [];
  List<String> errors = [];
  List<String> selectedCategories = [];

  void _updateSelectedItems(List<String> items) {
    setState(() {
      // selectedItems = items;
      selectedCategories = items;
      errors = [];
    });
  }

void _showMultiSelect() async {
  final List<String>? results = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return MultiSelect(
        items: categories, // Pass the categories map directly
        initialSelectedItems: selectedCategories,
        onSelectionChanged: _updateSelectedItems,
      );
    },
  );

  if (results != null) {
    setState(() {
      errors = [];
      selectedCategories = results;
      widget.onSelectionChanged(selectedCategories);
    });
  } else {
    setState(() {
      errors = ['Veuillez sélectionner au moins un élément.'];
    });
  }
}

  void _submit() {
    Navigator.pop(context, selectedCategories);
    widget.onSelectionChanged(selectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _showMultiSelect,
          child: Text('Sélectionnez des matières'),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: selectedCategories.map((category) {
            return Chip(
              label: Text(category),
              onDeleted: () {
                setState(() {
                  selectedCategories.remove(category);
                  // selectedItems.remove(category);
                });
              },
            );
          }).toList(),
        ),
        SizedBox(height: 10),
        FormError(errors: errors),
      ],
    );
  }
}
