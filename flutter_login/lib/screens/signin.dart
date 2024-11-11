import 'package:flutter/material.dart';
import '../widgets/social_login_buttons.dart';
import 'signup.dart';
import 'forgetpassword.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signInWithEmailPassword() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Navigate to home screen or show success message
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign In")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: signInWithEmailPassword,
              child: Text("Sign In"),
            ),
            SocialLoginButtons(), // Google and Facebook buttons
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text("Create an account"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/forgetpassword');
              },
              child: Text("Forgot password?"),
            ),
          ],
        ),
      ),
    );
  }
}
