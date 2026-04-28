import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Change Password screen
// Allows users to update their Firebase Auth password
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // Form controllers
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Password visibility toggles
  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;
  // Loading state
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1A1A2E),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Color(0xFFFCE4EC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                color: Color(0xFFC62828),
                size: 28,
              ),
            ),

            SizedBox(height: 20),

            // Title
            Text(
              'Update Password',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Enter your current password and choose a new one',
              style: TextStyle(fontSize: 14, color: Color(0xFF8E8E93)),
            ),

            SizedBox(height: 32),

            // Current password field
            _buildPasswordField(
              'Current Password',
              currentPasswordController,
              obscureCurrent,
              () {
                setState(() => obscureCurrent = !obscureCurrent);
              },
            ),
            SizedBox(height: 16),
            // New password field
            _buildPasswordField(
              'New Password',
              newPasswordController,
              obscureNew,
              () {
                setState(() => obscureNew = !obscureNew);
              },
            ),
            SizedBox(height: 16),
            // Confirm password field
            _buildPasswordField(
              'Confirm Password',
              confirmPasswordController,
              obscureConfirm,
              () {
                setState(() => obscureConfirm = !obscureConfirm);
              },
            ),

            SizedBox(height: 36),

            // Update button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFC62828),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: isLoading ? null : _changePassword,
                child: isLoading
                    ? SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        'Update Password',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build password field helper
  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool obscure,
    Function toggleObscure,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: 'Enter $label',
              hintStyle: TextStyle(color: Color(0xFFBDBDBD), fontSize: 15),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                color: Color(0xFF8E8E93),
                size: 22,
              ),
              suffixIcon: GestureDetector(
                onTap: () => toggleObscure(),
                child: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Color(0xFF8E8E93),
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Handle password change
  void _changePassword() async {
    // Local validation first
    if (currentPasswordController.text.isEmpty) {
      _showMessage('Please enter your current password', isError: true);
      return;
    }
    if (newPasswordController.text.isEmpty ||
        newPasswordController.text.length < 6) {
      _showMessage('New password must be at least 6 characters', isError: true);
      return;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      _showMessage('Passwords do not match', isError: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null || user.email == null) {
        throw Exception('No user is currently logged in.');
      }

      // Step 1: Re-authenticate — Firebase requires this before changing password
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPasswordController.text,
      );

      await user.reauthenticateWithCredential(credential);

      // Step 2: Now update to the new password
      await user.updatePassword(newPasswordController.text);

      if (mounted) {
        setState(() => isLoading = false);
        _showMessage('Password updated successfully!', isError: false);
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);

      String message = 'Failed to update password. Please try again.';

      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        message = 'Current password is incorrect.';
      } else if (e.code == 'weak-password') {
        message = 'New password must be at least 6 characters.';
      } else if (e.code == 'requires-recent-login') {
        message = 'Session expired. Please log out and log in again.';
      }

      if (mounted) {
        _showMessage(message, isError: true);
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        _showMessage('Something went wrong. Please try again.', isError: true);
      }
    }
  }

  // Show snackbar message
  void _showMessage(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Color(0xFFC62828) : Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
