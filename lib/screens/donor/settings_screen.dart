import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Settings screen for donors
// Contains app preferences and account options
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Notification toggle state
  bool notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings(); // Load saved preference when screen opens
  }

  // Load the saved notification toggle value from device storage
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Default to true if never saved before
      notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  // Save the notification toggle value to device storage
  Future<void> _saveNotificationSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            SizedBox(height: 20),

            // Title
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
            ),

            SizedBox(height: 28),

            // Preferences section
            _buildSectionTitle('Preferences'),
            SizedBox(height: 10),
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
              child: SwitchListTile(
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() => notificationsEnabled = value);
                  _saveNotificationSetting(value); // Persist to device
                },
                title: Text(
                  'Notifications',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                subtitle: Text(
                  'Receive alerts and updates',
                  style: TextStyle(fontSize: 13, color: Color(0xFF8E8E93)),
                ),
                secondary: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: Color(0xFF1565C0),
                    size: 22,
                  ),
                ),
                activeThumbColor: Color(0xFFC62828),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            SizedBox(height: 24),

            // Security section
            _buildSectionTitle('Security'),
            SizedBox(height: 10),
            _buildSettingsTile(
              icon: Icons.lock_outline_rounded,
              iconBg: Color(0xFFFCE4EC),
              iconColor: Color(0xFFC62828),
              title: 'Change Password',
              subtitle: 'Update your password',
              onTap: () => Navigator.pushNamed(context, '/change_password'),
            ),

            SizedBox(height: 24),

            // Information section
            _buildSectionTitle('Information'),
            SizedBox(height: 10),
            _buildSettingsTile(
              icon: Icons.info_outline_rounded,
              iconBg: Color(0xFFE8F5E9),
              iconColor: Color(0xFF2E7D32),
              title: 'About App',
              subtitle: 'Version 1.0.0',
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),

            SizedBox(height: 24),

            // Danger Zone section
            _buildSectionTitle('Danger Zone'),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFFFF5F5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Color(0xFFFFCDD2), width: 1),
              ),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFC62828),
                    size: 22,
                  ),
                ),
                title: Text(
                  'Delete Account',
                  style: TextStyle(
                    color: Color(0xFFC62828),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                subtitle: Text(
                  'Permanently delete your account',
                  style: TextStyle(color: Color(0xFFEF9A9A), fontSize: 12),
                ),
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFEF9A9A),
                  size: 22,
                ),
                onTap: () => _showDeleteDialog(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Build section title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Color(0xFF8E8E93),
        letterSpacing: 0.5,
      ),
    );
  }

  // Build settings tile
  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Function onTap,
  }) {
    return Container(
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
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Color(0xFF8E8E93)),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFFCCCCCC),
          size: 22,
        ),
        onTap: () => onTap(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  // Show delete account confirmation dialog
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Delete Account',
          style: TextStyle(
            color: Color(0xFFC62828),
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'This action cannot be undone. All your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Color(0xFF8E8E93))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleDeleteAccount(context);
            },
            child: Text(
              'Delete',
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

  // Permanently delete the user's account and all associated data
  Future<void> _handleDeleteAccount(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;
    final db = FirebaseFirestore.instance;

    try {
      // 1. Get user role to know which role collection to delete from
      final userDoc = await db.collection('users').doc(uid).get();
      final role = userDoc.data()?['role'] ?? 'donor';

      final batch = db.batch();

      // 2. Delete all responses this donor made across all blood requests
      if (role == 'donor') {
        final requests = await db.collection('blood_requests').get();
        for (final req in requests.docs) {
          batch.delete(req.reference.collection('responses').doc(uid));
        }
      }

      // 3. Delete all notifications for this user
      final notifications = await db
          .collection('notifications')
          .where('userId', isEqualTo: uid)
          .get();
      for (final doc in notifications.docs) {
        batch.delete(doc.reference);
      }

      // 4. Delete from role-specific collection
      final roleCollection = role == 'donor'
          ? 'donors'
          : role == 'hospital'
              ? 'hospitals'
              : 'admins';
      batch.delete(db.collection(roleCollection).doc(uid));

      // 5. Delete from users collection
      batch.delete(db.collection('users').doc(uid));

      await batch.commit();

      // 6. Delete Firebase Auth account
      await user.delete();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account permanently deleted'),
            backgroundColor: Color(0xFFC62828),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please log out and log in again to delete your account'),
              backgroundColor: Color(0xFFC62828),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
        // Firestore data was already deleted, sign them out
        await FirebaseAuth.instance.signOut();
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/welcome');
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete account: ${e.message}'),
              backgroundColor: Color(0xFFC62828),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete account. Please try again.'),
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
