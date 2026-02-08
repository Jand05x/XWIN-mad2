import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1A1A2E),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('All notifications cleared'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: Text(
              'Clear All',
              style: TextStyle(
                color: Color(0xFFC62828),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          _buildNotification(
            title: 'Blood Match Found!',
            message: 'Your blood type A+ is needed at Central Hospital',
            time: '2 hours ago',
            icon: Icons.check_circle_rounded,
            color: Color(0xFF2E7D32),
          ),
          _buildNotification(
            title: 'Urgent: O- Blood Needed',
            message: 'Emergency blood request - Regional Hospital',
            time: '5 hours ago',
            icon: Icons.warning_rounded,
            color: Color(0xFFC62828),
          ),
          _buildNotification(
            title: 'Eligibility Updated',
            message: 'You are now eligible to donate again',
            time: '1 day ago',
            icon: Icons.verified_rounded,
            color: Color(0xFF1565C0),
          ),
          _buildNotification(
            title: 'Event Reminder',
            message: 'Blood drive at City Hospital starts in 2 days',
            time: '3 days ago',
            icon: Icons.event_rounded,
            color: Color(0xFFF57C00),
          ),
        ],
      ),
    );
  }

  Widget _buildNotification({
    required String title,
    required String message,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(fontSize: 13, color: Color(0xFF8E8E93)),
                ),
                SizedBox(height: 6),
                Text(
                  time,
                  style: TextStyle(fontSize: 11, color: Color(0xFFBDBDBD)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
