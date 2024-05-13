import 'package:flutter/material.dart';

import '../constants.dart';
import '../ecrans/inscription/page_inscription.dart';

class AucunCompteText extends StatelessWidget {
  const AucunCompteText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Vous n'avez pas de compte ?",
          style: TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, PageInscription.routeName),
          child: const Text(
            "Inscription",
            style: TextStyle(fontSize: 16, color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
