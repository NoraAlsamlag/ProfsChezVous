import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

Future<bool> requestLocationPermission(BuildContext context) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    showLocationServiceDisabledDialog(context);
    return false;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      showPermissionDeniedDialog(context);
      return false;
    }
  } else if (permission == LocationPermission.deniedForever) {
    showPermissionDeniedForeverDialog(context);
    return false;
  }

  return true;
}

Future<void> showPermissionDeniedDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Autoriser l\'accès à la localisation'),
        content: Text(
          'Cette application a besoin de votre localisation pour fonctionner correctement.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

Future<void> showLocationServiceDisabledDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Services de localisation désactivés'),
        content: Text(
          'Veuillez activer les services de localisation de votre appareil.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

Future<void> showPermissionDeniedForeverDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Permission de localisation refusée'),
        content: Text(
          'Vous avez refusé la permission de localisation. Veuillez l\'activer dans les paramètres de votre appareil.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}