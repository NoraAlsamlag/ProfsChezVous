// import 'package:flutter/material.dart';

// import '../../constants.dart';
// import 'components/complete_profile_form.dart';

// class CompletionProfilEcrant extends StatelessWidget {
//   static String routeName = "/complete_profile";
  

//   const CompletionProfilEcrant({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final Map<String, dynamic>? args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

//     final String email = args?['email'] ?? '';
//     final String password = args?['password'] ?? '';
    
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sign Up'),
//       ),
//       body: SafeArea(
//         child: SizedBox(
//           width: double.infinity,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   const SizedBox(height: 16),
//                   const Text("Complete Profile", style: headingStyle),
//                   const Text(
//                     "Complétez vos informations ou continuez avec les médias sociaux.",
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 16),
//                   CompleteProfileForm(email: email,password: password,),
//                   const SizedBox(height: 30),
//                   Text(
//                     "En continuant, vous confirmez que vous acceptez nos conditions générales.",
//                     textAlign: TextAlign.center,
//                     style: Theme.of(context).textTheme.bodySmall,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
