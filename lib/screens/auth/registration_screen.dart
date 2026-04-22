import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController hospitalNameController = TextEditingController();
  final TextEditingController hospitalAddressController = TextEditingController();
  final TextEditingController adminCodeController = TextEditingController();

  String selectedRole = 'donor';
  String? selectedBloodType;
  bool isLoading = false;
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),

                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),

                SizedBox(height: 28),

                Text(
                  'Create\nAccount',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                    height: 1.15,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  'Join our lifesaving community',
                  style: TextStyle(fontSize: 15, color: Color(0xFF8E8E93)),
                ),

                SizedBox(height: 36),

                _buildLabel('Select Account Type'),
                SizedBox(height: 12),
                _buildRoleSelector(),

                SizedBox(height: 24),

                if (selectedRole == 'donor') ...[
                  _buildInputField(
                    'Full Name',
                    nameController,
                    Icons.person_outline_rounded,
                  ),
                  SizedBox(height: 16),
                  _buildInputField(
                    'Email',
                    emailController,
                    Icons.mail_outline_rounded,
                  ),
                  SizedBox(height: 16),
                  _buildInputField(
                    'Phone',
                    phoneController,
                    Icons.phone_outlined,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Blood Type',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedBloodType,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.water_drop_outlined,
                          color: Color(0xFF8E8E93),
                          size: 22,
                        ),
                      ),
                      hint: Text(
                        'Select blood type',
                        style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 15),
                      ),
                      items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                          .map(
                            (type) =>
                                DropdownMenuItem(value: type, child: Text(type)),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedBloodType = value),
                    ),
                  ),
                  SizedBox(height: 16),
                ] else if (selectedRole == 'hospital') ...[
                  _buildInputField(
                    'Hospital Name',
                    hospitalNameController,
                    Icons.local_hospital_rounded,
                  ),
                  SizedBox(height: 16),
                  _buildInputField(
                    'Email',
                    emailController,
                    Icons.mail_outline_rounded,
                  ),
                  SizedBox(height: 16),
                  _buildInputField(
                    'Phone',
                    phoneController,
                    Icons.phone_outlined,
                  ),
                  SizedBox(height: 16),
                  _buildInputField(
                    'Address',
                    hospitalAddressController,
                    Icons.location_on_outlined,
                  ),
                  SizedBox(height: 16),
                ] else ...[
                  _buildInputField(
                    'Name',
                    nameController,
                    Icons.person_outline_rounded,
                  ),
                  SizedBox(height: 16),
                  _buildInputField(
                    'Email',
                    emailController,
                    Icons.mail_outline_rounded,
                  ),
                  SizedBox(height: 16),
                  _buildInputField(
                    'Phone',
                    phoneController,
                    Icons.phone_outlined,
                  ),
                  SizedBox(height: 16),
                  _buildInputField(
                    'Admin Code',
                    adminCodeController,
                    Icons.key_rounded,
                  ),
                  SizedBox(height: 16),
                ],

                Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Create a password',
                      hintStyle: TextStyle(
                        color: Color(0xFFBDBDBD),
                        fontSize: 15,
                      ),
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
                        onTap: () =>
                            setState(() => obscurePassword = !obscurePassword),
                        child: Icon(
                          obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Color(0xFF8E8E93),
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 36),

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
                    onPressed: isLoading ? null : _handleRegister,
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
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(color: Color(0xFF8E8E93), fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Color(0xFFC62828),
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isPassword = false,
  }) {
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
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword ? obscurePassword : false,
            decoration: InputDecoration(
              hintText: 'Enter $label',
              hintStyle: TextStyle(color: Color(0xFFBDBDBD), fontSize: 15),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              prefixIcon: Icon(icon, color: Color(0xFF8E8E93), size: 22),
              suffixIcon: isPassword
                  ? GestureDetector(
                      onTap: () =>
                          setState(() => obscurePassword = !obscurePassword),
                      child: Icon(
                        obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Color(0xFF8E8E93),
                        size: 22,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF333333),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Row(
      children: [
        _buildRoleCard(
          role: 'donor',
          label: 'Donor',
          icon: Icons.bloodtype_rounded,
          color: Color(0xFFC62828),
        ),
        SizedBox(width: 12),
        _buildRoleCard(
          role: 'hospital',
          label: 'Hospital',
          icon: Icons.local_hospital_rounded,
          color: Color(0xFF1565C0),
        ),
        SizedBox(width: 12),
        _buildRoleCard(
          role: 'admin',
          label: 'Admin',
          icon: Icons.admin_panel_settings_rounded,
          color: Color(0xFF6A1B9A),
        ),
      ],
    );
  }

  Widget _buildRoleCard({
    required String role,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    bool isSelected = selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedRole = role),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.08) : Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? color : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 28,
                color: isSelected ? color : Color(0xFF8E8E93),
              ),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? color : Color(0xFF8E8E93),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleRegister() async {
    if (emailController.text.trim().isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    if (passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password must be at least 6 characters'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    bool isValid = false;
    String errorMsg = 'Please fill all fields';

    if (selectedRole == 'donor') {
      isValid = nameController.text.trim().isNotEmpty &&
          phoneController.text.trim().isNotEmpty &&
          selectedBloodType != null;
      errorMsg = 'Please fill name, phone and select blood type';
    } else if (selectedRole == 'hospital') {
      isValid = hospitalNameController.text.trim().isNotEmpty &&
          phoneController.text.trim().isNotEmpty &&
          hospitalAddressController.text.trim().isNotEmpty;
      errorMsg = 'Please fill hospital name, phone and address';
    } else {
      isValid = nameController.text.trim().isNotEmpty &&
          phoneController.text.trim().isNotEmpty &&
          adminCodeController.text.trim().isNotEmpty;
      errorMsg = 'Please fill all fields and enter admin code';
      if (isValid && adminCodeController.text.trim() != 'ADMIN2024') {
        isValid = false;
        errorMsg = 'Invalid admin code';
      }
    }

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text,
          );

      Map<String, dynamic> userData = {
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'role': selectedRole,
        'createdAt': FieldValue.serverTimestamp(),
      };

      if (selectedRole == 'donor') {
        userData['name'] = nameController.text.trim();
        userData['bloodType'] = selectedBloodType;
      } else if (selectedRole == 'hospital') {
        userData['name'] = hospitalNameController.text.trim();
        userData['address'] = hospitalAddressController.text.trim();
        userData['verified'] = false;
      } else {
        userData['name'] = nameController.text.trim();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userData);

      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);

      String message = 'Registration failed. Please try again.';

      if (e.code == 'email-already-in-use') {
        message = 'An account already exists with this email.';
      } else if (e.code == 'weak-password') {
        message = 'Password must be at least 6 characters.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Color(0xFFC62828),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong. Please try again.'),
            backgroundColor: Color(0xFFC62828),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    hospitalNameController.dispose();
    hospitalAddressController.dispose();
    adminCodeController.dispose();
    super.dispose();
  }
}
