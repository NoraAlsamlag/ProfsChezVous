import 'package:flutter/material.dart';

Future<void> montrerDialogPersonnalise({
  required BuildContext context,
  required String titre,
  required String contenu,
  required String texteBoutonConfirmer,
  required VoidCallback onConfirmer,
  required String texteBoutonAnnuler,
  VoidCallback? onAnnuler,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          titre,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                contenu,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text(
              texteBoutonAnnuler,
              style: const TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              if (onAnnuler != null) {
                onAnnuler();
              }
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: Text(texteBoutonConfirmer),
            onPressed: () {
              Navigator.of(context).pop();
              onConfirmer();
            },
          ),
        ],
      );
    },
  );
}
