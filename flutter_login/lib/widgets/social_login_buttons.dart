import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback? onGoogleSignIn;
  final VoidCallback? onFacebookSignIn;

  SocialLoginButtons({this.onGoogleSignIn, this.onFacebookSignIn});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Google Sign-In Button
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black, backgroundColor: Colors.white, // Text color
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          onPressed: onGoogleSignIn,
          icon: FaIcon(
            FontAwesomeIcons.google,
            color: Colors.red, // Google icon color
          ),
          label: Text(
            "Sign in with Google",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 10),

        // Facebook Sign-In Button
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Color(0xFF1877F2), // Text color
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: onFacebookSignIn,
          icon: FaIcon(
            FontAwesomeIcons.facebook,
            color: Colors.white, // Facebook icon color
          ),
          label: Text(
            "Sign in with Facebook",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
