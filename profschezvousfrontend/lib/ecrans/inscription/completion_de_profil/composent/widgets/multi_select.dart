import 'package:flutter/material.dart';

class MultiSelect extends StatefulWidget {
  final Map<String, List<String>> items;
  final List<String> initialSelectedItems;
  final ValueChanged<List<String>> onSelectionChanged;

  const MultiSelect({
    Key? key,
    required this.items,
    required this.initialSelectedItems,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _MultiSelectState createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  late List<String> _selectedItems = [];
  String _searchQuery = '';

  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    Navigator.pop(context, _selectedItems);
    widget.onSelectionChanged(_selectedItems);
  }

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.initialSelectedItems);
  }

  List<Widget> _getFilteredItems() {
  final filteredItems = <Widget>[];
  final searchRegExp = RegExp('^${RegExp.escape(_searchQuery.toLowerCase())}');

  if (_searchQuery.isEmpty) {
    // If the search query is empty, show all categories and items
    widget.items.forEach((category, items) {
      filteredItems.add(
        ExpansionTile(
          title: Text(category),
          children: items.map((item) {
            return CheckboxListTile(
              value: _selectedItems.contains(item),
              title: Text(item),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (isChecked) => _itemChange(item, isChecked!),
            );
          }).toList(),
        ),
      );
    });
  } else {
    // Filter categories and items based on the search query
    widget.items.forEach((category, items) {
      final matchingItems = items.where((item) =>
          searchRegExp.hasMatch(item.toLowerCase()));

      if (searchRegExp.hasMatch(category.toLowerCase())) {
        filteredItems.add(
          ExpansionTile(
            initiallyExpanded: true,
            title: Text(category),
            children: items.map((item) {
              return CheckboxListTile(
                value: _selectedItems.contains(item),
                title: Text(item),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (isChecked) => _itemChange(item, isChecked!),
              );
            }).toList(),
          ),
        );
      } else if (matchingItems.isNotEmpty) {
        filteredItems.add(
          ExpansionTile(
            initiallyExpanded: true, // Expand the category if any of its items match the search query
            title: Text(category),
            children: matchingItems.map((item) {
              return CheckboxListTile(
                value: _selectedItems.contains(item),
                title: Text(item),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (isChecked) => _itemChange(item, isChecked!),
              );
            }).toList(),
          ),
        );
      }
    });
  }

  // Sort the filtered items alphabetically
  filteredItems.sort((a, b) {
    final titleA = (a as ExpansionTile).title.toString().toLowerCase();
    final titleB = (b as ExpansionTile).title.toString().toLowerCase();
    return titleA.compareTo(titleB);
  });

  return filteredItems;
}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sélectionnez des matières'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Rechercher',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: ListBody(
                children: _getFilteredItems(),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Valider'),
        ),
      ],
    );
  }
}