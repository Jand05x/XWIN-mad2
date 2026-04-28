import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Gate that checks if user is logged in and routes to correct screen
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  // Maps user role to the route they should go to
  String _getRouteForRole(String role) {
    if (role == 'hospital') return '/hospital_dashboard';
    if (role == 'admin') return '/admin_dashboard';
    return '/home';
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes (login/logout)
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Still checking if user is logged in
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFC62828)),
            ),
          );
        }

        // User is logged in - check their role in Firestore
        if (snapshot.hasData) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, userSnapshot) {
              // Still loading user data
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: CircularProgressIndicator(color: Color(0xFFC62828)),
                  ),
                );
              }

              // User exists in database - get their role and navigate
              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                String role = userSnapshot.data!.get('role') ?? 'donor';
                String route = _getRouteForRole(role);
                // Navigate after build completes
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacementNamed(context, route);
                });
              } else {
                // User not in database yet - go to home
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacementNamed(context, '/home');
                });
              }
              return Scaffold(backgroundColor: Colors.white, body: SizedBox());
            },
          );
        }

        // No user logged in - go to welcome screen
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/welcome');
        });
        return Scaffold(backgroundColor: Colors.white, body: SizedBox());
      },
    );
  }
}
