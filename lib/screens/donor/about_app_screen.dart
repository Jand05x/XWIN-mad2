import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('About'),
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
          children: [
            SizedBox(height: 10),

            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFC62828), Color(0xFFE53935)],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(
                Icons.water_drop_rounded,
                size: 44,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 20),

            Text(
              'XwinLink',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
            ),
            SizedBox(height: 6),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8E8E93),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(height: 30),

            _buildSection(
              'About',
              'This blood donation app connects donors with hospitals and blood banks in need. '
                  'Our mission is to save lives by making blood donation easier and more accessible for everyone.',
            ),

            SizedBox(height: 24),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Features',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ),
            SizedBox(height: 12),
            _buildFeature(
              Icons.search_rounded,
              Color(0xFFC62828),
              'Find urgent blood requests near you',
            ),
            _buildFeature(
              Icons.event_rounded,
              Color(0xFF1565C0),
              'Discover donation events and campaigns',
            ),
            _buildFeature(
              Icons.timeline_rounded,
              Color(0xFF2E7D32),
              'Track your donation history',
            ),
            _buildFeature(
              Icons.menu_book_rounded,
              Color(0xFF6A1B9A),
              'Learn about blood donation',
            ),

            SizedBox(height: 24),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ),
            SizedBox(height: 12),
            _buildContactRow(
              Icons.mail_outline_rounded,
              'support@xwinlink.com',
            ),
            SizedBox(height: 8),
            _buildContactRow(Icons.phone_outlined, '+964 750 123 4567'),

            SizedBox(height: 30),

            Text(
              '2025 XwinLink. All rights reserved.',
              style: TextStyle(fontSize: 12, color: Color(0xFFBDBDBD)),
            ),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        SizedBox(height: 8),
        Text(
          body,
          style: TextStyle(fontSize: 15, height: 1.6, color: Color(0xFF555555)),
        ),
      ],
    );
  }

  Widget _buildFeature(IconData icon, Color color, String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFFC62828), size: 20),
        SizedBox(width: 10),
        Text(text, style: TextStyle(fontSize: 14, color: Color(0xFF555555))),
      ],
    );
  }
}
