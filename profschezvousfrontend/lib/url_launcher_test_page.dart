// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class UrlLauncherTestPage extends StatelessWidget {
//   const UrlLauncherTestPage({Key? key}) : super(key: key);

//   void _launchURL() async {
//     final Uri url = Uri.parse('https://www.google.com');
//     if (await canLaunchUrl(url)) {
//       await launchUrl(
//         url,
//         mode: LaunchMode.externalApplication,
//       );
//     } else {
//       print('Impossible d\'ouvrir le lien $url');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Test URL Launcher'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _launchURL,
//           child: Text('Ouvrir Google'),
//         ),
//       ),
//     );
//   }
// }
