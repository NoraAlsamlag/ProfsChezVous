// import 'package:test/test.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/testing.dart';
// import 'dart:convert';

// import 'prof_api.dart'; // Update this to the correct path

// void main() {
//   group('enregistrerProfesseur', () {
//     test('should register professor successfully', () async {
//       // Arrange
//       final mockResponse = http.Response('', 201);
//       final mockClient = MockClient((request) async {
//         return mockResponse;
//       });

//       final email = 'test@example.com';
//       final motDePasse = 'password123';
//       final nom = 'Doe';
//       final prenom = 'John';
//       final dateNaissance = '1980-01-01';
//       final ville = 'Paris';
//       final numeroTelephone = '0123456789';
//       final latitude = '48.8566';
//       final longitude = '2.3522';
//       final diplomePath = 'path/to/diplome.pdf';
//       final cvPath = 'path/to/cv.pdf';
//       final matieresAEnseigner = [14, 16, 19, 22, 24, 26];
//       final niveauEtude = 'Doctorate';

//       // Act
//       await enregistrerProfesseur(
//         email: email,
//         motDePasse: motDePasse,
//         nom: nom,
//         prenom: prenom,
//         dateNaissance: dateNaissance,
//         ville: ville,
//         numeroTelephone: numeroTelephone,
//         latitude: latitude,
//         longitude: longitude,
//         diplomePath: diplomePath,
//         cvPath: cvPath,
//         matieresAEnseigner: matieresAEnseigner,
//         niveauEtude: niveauEtude,
//       );

//       // Assert
//       // Add your assertions here
//     });

//     test('should handle registration failure', () async {
//       // Arrange
//       final mockResponse = http.Response('{"error": "Something went wrong"}', 400);
//       final mockClient = MockClient((request) async {
//         return mockResponse;
//       });

//       final email = 'test@example.com';
//       final motDePasse = 'password123';
//       final nom = 'Doe';
//       final prenom = 'John';
//       final dateNaissance = '1980-01-01';
//       final ville = 'Paris';
//       final numeroTelephone = '0123456789';
//       final latitude = '48.8566';
//       final longitude = '2.3522';
//       final diplomePath = '/data/user/0/com.example.profschezvousfrontend/cache/file_picker/1715957726037/uml3.png;
//       final cvPath = '/data/user/0/com.example.profschezvousfrontend/cache/file_picker/1715957726037/uml3.png';
//       final matieresAEnseigner = [14, 16, 19, 22, 24, 26];
//       final niveauEtude = 'Doctorate';

//       // Act & Assert
//       expect(
//         () async => await enregistrerProfesseur(
//           email: email,
//           motDePasse: motDePasse,
//           nom: nom,
//           prenom: prenom,
//           dateNaissance: dateNaissance,
//           ville: ville,
//           numeroTelephone: numeroTelephone,
//           latitude: latitude,
//           longitude: longitude,
//           diplomePath: diplomePath,
//           cvPath: cvPath,
//           matieresAEnseigner: matieresAEnseigner,
//           niveauEtude: niveauEtude,
//         ),
//         throwsException,
//       );
//     });
//   });
// }
