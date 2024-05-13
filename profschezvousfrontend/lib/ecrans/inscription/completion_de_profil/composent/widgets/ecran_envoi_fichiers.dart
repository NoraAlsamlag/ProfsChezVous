import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class EcranEnvoiFichiers extends StatefulWidget {
  final Function(String?) onCheminFichierCV;
  final Function(String?) onCheminFichierDiplome;

  const EcranEnvoiFichiers({
    Key? key,
    required this.onCheminFichierDiplome,
    required this.onCheminFichierCV,
  }) : super(key: key);
  @override
  _EcranEnvoiFichiersState createState() => _EcranEnvoiFichiersState();
}

class _EcranEnvoiFichiersState extends State<EcranEnvoiFichiers> {
  String? cheminFichierCV;
  String? cheminFichierDiplome;

  Future<void> choisirFichierCV() async {
    FilePickerResult? resultat = await FilePicker.platform.pickFiles();
    if (resultat != null) {
      setState(() {
        cheminFichierCV = resultat.files.single.path;
        widget.onCheminFichierCV(cheminFichierCV);
      });
    }
  }

  Future<void> choisirFichierDiplome() async {
    FilePickerResult? resultat = await FilePicker.platform.pickFiles();
    if (resultat != null) {
      setState(() {
        cheminFichierDiplome = resultat.files.single.path;
        widget.onCheminFichierDiplome(cheminFichierDiplome);
      });
    }
  }

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: choisirFichierCV,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: const Center(
                  child: Text(
                    'Choisir le fichier CV',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: GestureDetector(
              onTap: choisirFichierDiplome,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: const Center(
                  child: Text(
                    'Choisir le fichier Diplôme',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
}