import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // This stream fires immediately with the current auth state,
      // then again whenever the user logs in or out
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Still checking auth state — show a loading spinner
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFC62828)),
            ),
          );
        }

        // User IS logged in — skip welcome, go straight to home
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/home');
          });
          return Scaffold(backgroundColor: Colors.white, body: SizedBox());
        }

        // User is NOT logged in — go to welcome screen
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/welcome');
        });
        return Scaffold(backgroundColor: Colors.white, body: SizedBox());
      },
    );
  }
}
