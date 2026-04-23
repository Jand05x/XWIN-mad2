import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

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

  File? idImageFile;
  File? selfieImageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(bool isId) async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) {
      setState(() {
        if (isId) {
          idImageFile = File(picked.path);
        } else {
          selfieImageFile = File(picked.path);
        }
      });
    }
  }

  void _handleRegister() async {
    if (emailController.text.trim().isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all required fields'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    if (passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password must be at least 6 characters'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

      String uid = userCredential.user!.uid;

      Map<String, dynamic> userData = {
        'uid': uid,
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'role': selectedRole,
        'createdAt': FieldValue.serverTimestamp(),
      };

      String targetCollection;

      if (selectedRole == 'donor') {
        targetCollection = 'donors';
        userData['name'] = nameController.text.trim();
        userData['bloodType'] = selectedBloodType;
        userData['verificationStatus'] = 'pending';
        if (idImageFile != null) {
          userData['idImageBase64'] = base64Encode(await idImageFile!.readAsBytes());
        }
        if (selfieImageFile != null) {
          userData['selfieImageBase64'] = base64Encode(await selfieImageFile!.readAsBytes());
        }
      } else if (selectedRole == 'hospital') {
        targetCollection = 'hospitals';
        userData['name'] = hospitalNameController.text.trim();
        userData['address'] = hospitalAddressController.text.trim();
        userData['verified'] = false;
      } else {
        targetCollection = 'admins';
        userData['name'] = nameController.text.trim();
      }

      // Save to role-specific collection
      await FirebaseFirestore.instance.collection(targetCollection).doc(uid).set(userData);

      // Save to master users collection
      await FirebaseFirestore.instance.collection('users').doc(uid).set(userData);

      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Account created successfully!'),
            backgroundColor: const Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        if (selectedRole == 'donor') {
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else if (selectedRole == 'hospital') {
          Navigator.pushReplacementNamed(context, '/hospital_dashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/admin_dashboard');
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);
      String message = e.message ?? 'Registration failed';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: const Color(0xFFC62828),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Something went wrong. Please try again.'),
            backgroundColor: const Color(0xFFC62828),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Color(0xFF333333)),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Create\nAccount',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E), height: 1.15),
                ),
                const SizedBox(height: 8),
                const Text('Join our lifesaving community', style: TextStyle(fontSize: 15, color: Color(0xFF8E8E93))),
                const SizedBox(height: 36),
                _buildLabel('Select Account Type'),
                const SizedBox(height: 12),
                _buildRoleSelector(),
                const SizedBox(height: 24),
                if (selectedRole == 'donor') ...[
                  _buildInputField('Full Name', nameController, Icons.person_outline_rounded),
                  const SizedBox(height: 16),
                  _buildInputField('Email', emailController, Icons.mail_outline_rounded),
                  const SizedBox(height: 16),
                  _buildInputField('Phone', phoneController, Icons.phone_outlined),
                  const SizedBox(height: 16),
                  _buildLabel('Blood Type'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(14)),
                    child: DropdownButtonFormField<String>(
                      value: selectedBloodType,
                      decoration: const InputDecoration(border: InputBorder.none, icon: Icon(Icons.water_drop_outlined, color: Color(0xFF8E8E93), size: 22)),
                      hint: const Text('Select blood type', style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 15)),
                      items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                          .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                          .toList(),
                      onChanged: (value) => setState(() => selectedBloodType = value),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildVerificationSection(),
                ] else if (selectedRole == 'hospital') ...[
                  _buildInputField('Hospital Name', hospitalNameController, Icons.local_hospital_rounded),
                  const SizedBox(height: 16),
                  _buildInputField('Email', emailController, Icons.mail_outline_rounded),
                  const SizedBox(height: 16),
                  _buildInputField('Phone', phoneController, Icons.phone_outlined),
                  const SizedBox(height: 16),
                  _buildInputField('Address', hospitalAddressController, Icons.location_on_outlined),
                  const SizedBox(height: 16),
                ] else ...[
                  _buildInputField('Name', nameController, Icons.person_outline_rounded),
                  const SizedBox(height: 16),
                  _buildInputField('Email', emailController, Icons.mail_outline_rounded),
                  const SizedBox(height: 16),
                  _buildInputField('Phone', phoneController, Icons.phone_outlined),
                  const SizedBox(height: 16),
                  _buildInputField('Admin Code', adminCodeController, Icons.key_rounded),
                  const SizedBox(height: 16),
                ],
                _buildLabel('Password'),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(14)),
                  child: TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Create a password',
                      hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 15),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF8E8E93), size: 22),
                      suffixIcon: GestureDetector(
                        onTap: () => setState(() => obscurePassword = !obscurePassword),
                        child: Icon(obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Color(0xFF8E8E93), size: 22),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC62828),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: isLoading ? null : _handleRegister,
                    child: isLoading
                        ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                        : const Text('Sign Up', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? ', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 14)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text('Sign In', style: TextStyle(color: Color(0xFFC62828), fontWeight: FontWeight.w700, fontSize: 14)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadBox(String label, IconData icon, File? file, bool isId) {
    return GestureDetector(
      onTap: () => _pickImage(isId),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: file != null ? Colors.transparent : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: file != null ? const Color(0xFFC62828) : const Color(0xFFE0E0E0), width: file != null ? 2 : 1),
        ),
        child: file != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(file, fit: BoxFit.cover),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Color(0xFFC62828), shape: BoxShape.circle),
                        child: const Icon(Icons.check, color: Colors.white, size: 12),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: const Color(0xFF8E8E93), size: 28),
                  const SizedBox(height: 8),
                  Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF8E8E93), fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  const Text('Tap to upload', style: TextStyle(fontSize: 11, color: Color(0xFFBDBDBD))),
                ],
              ),
      ),
    );
  }

  Widget _buildVerificationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3F3),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFFCDD2), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.verified_user_outlined, color: Color(0xFFC62828), size: 18),
                  SizedBox(width: 8),
                  Text('Identity Verification', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFC62828))),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Upload your national ID and a selfie. An admin will review and verify your account before you can donate.',
                style: TextStyle(fontSize: 12, color: Color(0xFF8E8E93), height: 1.5),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _buildImageUploadBox('National ID\n(front)', Icons.credit_card_rounded, idImageFile, true)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildImageUploadBox('Selfie\nPhoto', Icons.face_retouching_natural_rounded, selfieImageFile, false)),
                ],
              ),
              if (idImageFile != null && selfieImageFile != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8)),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle_outline_rounded, color: Color(0xFF2E7D32), size: 16),
                      SizedBox(width: 8),
                      Text('Documents ready — pending admin review', style: TextStyle(fontSize: 12, color: Color(0xFF2E7D32), fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(14)),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter $label',
              hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 15),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              prefixIcon: Icon(icon, color: const Color(0xFF8E8E93), size: 22),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF333333)));
  }

  Widget _buildRoleSelector() {
    return Row(
      children: [
        _buildRoleCard(role: 'donor', label: 'Donor', icon: Icons.bloodtype_rounded, color: const Color(0xFFC62828)),
        const SizedBox(width: 12),
        _buildRoleCard(role: 'hospital', label: 'Hospital', icon: Icons.local_hospital_rounded, color: const Color(0xFF1565C0)),
        const SizedBox(width: 12),
        _buildRoleCard(role: 'admin', label: 'Admin', icon: Icons.admin_panel_settings_rounded, color: const Color(0xFF6A1B9A)),
      ],
    );
  }

  Widget _buildRoleCard({required String role, required String label, required IconData icon, required Color color}) {
    bool isSelected = selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedRole = role),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.08) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isSelected ? color : Colors.transparent, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: isSelected ? color : const Color(0xFF8E8E93)),
              const SizedBox(height: 8),
              Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? color : const Color(0xFF8E8E93))),
            ],
          ),
        ),
      ),
    );
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