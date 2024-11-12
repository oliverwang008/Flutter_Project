import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialLoginButtons extends StatelessWidget {
  // Function to handle Google Sign-In
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // User canceled the sign-in
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signed in with Google")),
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google sign-in failed")),
      );
    }
  }

  // Function to handle Facebook Sign-In
  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.tokenString);
        await FirebaseAuth.instance.signInWithCredential(credential);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signed in with Facebook")),
        );
      } else {
        print("Facebook sign-in failed: ${result.status}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Facebook sign-in failed")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Facebook sign-in failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Google Sign-In Button
        ElevatedButton.icon(
          onPressed: () => _signInWithGoogle(context),
          icon: FaIcon(FontAwesomeIcons.google, color: Colors.white),
          label: Text("Sign in with Google",
              style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.redAccent,
            minimumSize: Size(double.infinity, 50),
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        SizedBox(height: 10),

        // Facebook Sign-In Button
        ElevatedButton.icon(
          onPressed: () => _signInWithFacebook(context),
          icon: FaIcon(FontAwesomeIcons.facebook, color: Colors.white),
          label: Text("Sign in with Facebook",
              style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Color(0xFF1877F2),
            minimumSize: Size(double.infinity, 50),
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ],
    );
  }
}
