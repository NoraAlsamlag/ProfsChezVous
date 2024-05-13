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
  'Fondamental': ['Français', 'Arabe', 'Mathématiques'],
  'Collège': ['Français', 'Anglais', 'Arabe', 'Mathématiques', 'Physique-Chimie', 'Histoire-Géographie', 'Instruction Islamique', 'Sciences Naturelles', 'Instruction Civique', 'EPS activités physiques'],
  'Lycée': ['Anglais', 'Histoire-Géographie', 'Instruction Islamique', 'Philosophie', 'EPS activités physiques', 'الإسلامي التشريع', 'الإسلامي الفكر'],
  'Sciences Naturelles (Lycée)': ['Sciences Naturelles 5C', 'Sciences Naturelles 5D', 'Sciences Naturelles 6C', 'Sciences Naturelles 6D', 'Sciences Naturelles 7C', 'Sciences Naturelles 7D'],
  'Mathématiques (Lycée)': ['Mathématiques 5C', 'Mathématiques 5D', 'Mathématiques 6C', 'Mathématiques 6D', 'Mathématiques 7C', 'Mathématiques 7D'],
  'Arabe (Lycée)': ['Arabe 5C', 'Arabe 5D', 'Arabe 6C', 'Arabe 6D', 'Arabe 7C', 'Arabe 7D'],
  'Français (Lycée)': ['Français 5C', 'Français 5D', 'Français 6C', 'Français 6D', 'Français 7C', 'Français 7D'],
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
