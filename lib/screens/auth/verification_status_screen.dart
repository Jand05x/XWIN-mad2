import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerificationStatusScreen extends StatelessWidget {
  final String status;

  const VerificationStatusScreen({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isPending = status == 'pending';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: isPending
                      ? const Color(0xFFFFF3E0)
                      : const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  isPending
                      ? Icons.hourglass_top_rounded
                      : Icons.cancel_rounded,
                  size: 50,
                  color: isPending
                      ? const Color(0xFFF57C00)
                      : const Color(0xFFC62828),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                isPending
                    ? 'Account Under Review'
                    : 'Account Rejected',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                isPending
                    ? 'Your identity verification is being reviewed by an admin. You will be able to access the app once approved.'
                    : 'Your verification was rejected. Please contact support or create a new account with valid documents.',
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF8E8E93),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC62828),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/welcome');
                    }
                  },
                  child: Text(
                    isPending ? 'Sign Out' : 'Sign Out & Re-register',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
