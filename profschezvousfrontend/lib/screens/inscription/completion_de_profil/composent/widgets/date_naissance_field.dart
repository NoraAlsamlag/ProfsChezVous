import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateNaissanceField extends StatefulWidget {
  final Function(String?) onDateSelected;

  const DateNaissanceField({Key? key, required this.onDateSelected})
      : super(key: key);

  @override
  _DateNaissanceFieldState createState() => _DateNaissanceFieldState();
}

class _DateNaissanceFieldState extends State<DateNaissanceField> {
  DateTime? selectedDate;

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale("fr", "FR"),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        widget.onDateSelected(formatDate(picked));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        _selectDate(context);
      },
      readOnly: true,
      controller: TextEditingController(
        text: selectedDate != null ? formatDate(selectedDate!) : '',
      ),
      decoration: const InputDecoration(
        labelText: "Date de naissance",
        hintText: "Sélectionnez votre date de naissance",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}