import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/signin.dart';
import 'screens/signup.dart';
import 'screens/forgetpassword.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/signin',
      routes: {
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/forgetpassword': (context) => ForgetPasswordScreen(),
      },
    );
  }
}
