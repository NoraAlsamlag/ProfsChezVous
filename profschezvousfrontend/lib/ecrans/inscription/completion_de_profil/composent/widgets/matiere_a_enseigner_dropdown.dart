import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../../components/form_error.dart';
import '../../../../../constants.dart';
import 'multi_select.dart';

class MatiereAEnseigneeDropdown extends StatefulWidget {
  final ValueChanged<List<int>> onSelectionChanged;

  const MatiereAEnseigneeDropdown({
    Key? key,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _MatiereAEnseigneeDropdownState createState() => _MatiereAEnseigneeDropdownState();
}

class _MatiereAEnseigneeDropdownState extends State<MatiereAEnseigneeDropdown> {
  Map<String, List<Map<String, dynamic>>> categories = {};
  List<int> selectedMatieresIds = [];
  List<String> errors = [];

  @override
  void initState() {
    super.initState();
    _fetchCategoriesAndMatieres();
  }

  Future<void> _fetchCategoriesAndMatieres() async {
    try {
      final response = await http.get(Uri.parse('$domaine/api/obtenir_categories_et_matieres/'));
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> data = json.decode(response.body);
          data.forEach((key, value) {
            categories[key] = List<Map<String, dynamic>>.from(value);
          });
        });
      } else {
        setState(() {
          errors = ['Erreur lors de la récupération des données.'];
        });
      }
    } catch (e) {
      setState(() {
        errors = ['Erreur de connexion.'];
      });
    }
  }

  void _updateSelectedItems(List<int> items) {
    setState(() {
      selectedMatieresIds = items;
      errors = [];
    });
  }

  void _showMultiSelect() async {
    final List<int>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(
          items: categories,
          initialSelectedItems: selectedMatieresIds,
          onSelectionChanged: _updateSelectedItems,
        );
      },
    );

    if (results != null) {
      setState(() {
        errors = [];
        selectedMatieresIds = results;
        widget.onSelectionChanged(selectedMatieresIds);
      });
    } else {
      setState(() {
        errors = ['Veuillez sélectionner au moins un élément.'];
      });
    }
  }

  void _submit() {
    Navigator.pop(context, selectedMatieresIds);
    widget.onSelectionChanged(selectedMatieresIds);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _showMultiSelect,
          child: const Text('Sélectionnez des matières'),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: selectedMatieresIds.map((id) {
            String? label;
            categories.forEach((key, value) {
              value.forEach((matiere) {
                if (matiere['id'] == id) {
                  label = matiere['nom_complet'];
                }
              });
            });
            return Chip(
              label: Text(label ?? ''),
              onDeleted: () {
                setState(() {
                  selectedMatieresIds.remove(id);
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        FormError(errors: errors),
      ],
    );
  }
}
