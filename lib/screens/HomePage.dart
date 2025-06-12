// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'Login.dart';
// import 'Register.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   void _logout(BuildContext context) async {
//     const storage = FlutterSecureStorage();
//     await storage.delete(key: 'token');
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginPage()),
//       (route) => false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Home Page"),
//         actions: [
//           IconButton(
//             onPressed: () => _logout(context),
//             icon: const Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: Center(
//         child: ElevatedButton(
//           child: const Text("Go to Work Page"),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const WorkPage()),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
