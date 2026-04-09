import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String displayName = '';
  String displayEmail = '';
  String displayPhone = '';
  String displayBloodType = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Load saved profile data from device storage
  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;

    setState(() {
      displayName = prefs.getString('profile_name') ?? 'User';
      displayEmail = prefs.getString('profile_email') ?? user?.email ?? '';
      displayPhone = prefs.getString('profile_phone') ?? '';
      displayBloodType = prefs.getString('profile_blood_type') ?? '';
    });
  }

  // Save updated profile info to SharedPreferences
  Future<void> _saveProfile(
    String name,
    String email,
    String phone,
    String bloodType,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', name);
    await prefs.setString('profile_email', email);
    await prefs.setString('profile_phone', phone);
    await prefs.setString('profile_blood_type', bloodType);
  }

  void _showEditDialog() {
    final nameCtrl = TextEditingController(text: displayName);
    final emailCtrl = TextEditingController(text: displayEmail);
    final phoneCtrl = TextEditingController(text: displayPhone);
    final bloodCtrl = TextEditingController(text: displayBloodType);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditField('Name', nameCtrl, Icons.person_outline),
              SizedBox(height: 12),
              _buildEditField('Email', emailCtrl, Icons.mail_outline),
              SizedBox(height: 12),
              _buildEditField('Phone', phoneCtrl, Icons.phone_outlined),
              SizedBox(height: 12),
              _buildEditField(
                'Blood Type',
                bloodCtrl,
                Icons.water_drop_outlined,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Color(0xFF8E8E93))),
          ),
          TextButton(
            onPressed: () async {
              await _saveProfile(
                nameCtrl.text.trim(),
                emailCtrl.text.trim(),
                phoneCtrl.text.trim(),
                bloodCtrl.text.trim(),
              );
              setState(() {
                displayName = nameCtrl.text.trim();
                displayEmail = emailCtrl.text.trim();
                displayPhone = phoneCtrl.text.trim();
                displayBloodType = bloodCtrl.text.trim();
              });
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Color(0xFFC62828),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: Color(0xFF8E8E93)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(24, 28, 24, 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFC62828), Color(0xFFE53935)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            size: 44,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _showEditDialog,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Color(0xFFC62828),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      displayName.isNotEmpty ? displayName : 'User',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      displayEmail,
                      style: TextStyle(fontSize: 14, color: Color(0xFF8E8E93)),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildInfoRow(
                      Icons.phone_rounded,
                      'Phone',
                      displayPhone.isNotEmpty ? displayPhone : 'Not set',
                    ),
                    _buildInfoRow(
                      Icons.water_drop_rounded,
                      'Blood Type',
                      displayBloodType.isNotEmpty
                          ? displayBloodType
                          : 'Not set',
                    ),
                    _buildInfoRow(Icons.star_rounded, 'Points', '240'),
                    _buildInfoRow(Icons.favorite_rounded, 'Donations', '12'),

                    SizedBox(height: 20),

                    _buildButton(
                      'Edit Profile',
                      Icons.edit_outlined,
                      Color(0xFF1565C0),
                      () => _showEditDialog(),
                    ),
                    SizedBox(height: 10),
                    _buildButton(
                      'Change Password',
                      Icons.lock_outline_rounded,
                      Color(0xFFF5A623),
                      () => Navigator.pushNamed(context, '/change_password'),
                    ),
                    SizedBox(height: 10),
                    _buildButton(
                      'Logout',
                      Icons.logout_rounded,
                      Color(0xFFC62828),
                      () => _showLogoutDialog(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Color(0xFFC62828), size: 22),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 15, color: Color(0xFF8E8E93)),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    String label,
    IconData icon,
    Color color,
    Function onTap,
  ) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Logout', style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Color(0xFF8E8E93))),
          ),
          TextButton(
            onPressed: () => _handleLogout(context),
            child: Text(
              'Logout',
              style: TextStyle(
                color: Color(0xFFC62828),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    Navigator.pop(context);
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign out. Please try again.'),
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
}
