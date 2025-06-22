// import 'package:flutter/material.dart';

// import 'screens/login_page.dart';
// import 'screens/register_page.dart';
// import 'screens/main_page.dart';
// // import 'screens/student_page.dart';
// // import 'screens/class_page.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'EduHPC',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       initialRoute: '/',
//       routes: {
//         '/': (context) => const LoginPage(),
//         '/register': (context) => const RegisterPage(),
//         '/main': (context) => const MainPage(),
//         // '/students': (context) => const StudentPage(),  //
//         // '/classes': (context) => const ClassPage(),     // 
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';

import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduHPC',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const LoginPage());
          case '/register':
            return MaterialPageRoute(builder: (_) => const RegisterPage());
          case '/main':
            final user = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(builder: (_) => MainPage(user: user));
          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text('Không tìm thấy trang')),
              ),
            );
        }
      },
    );
  }
}
