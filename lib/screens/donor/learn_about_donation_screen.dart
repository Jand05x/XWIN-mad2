import 'package:flutter/material.dart';

class LearnAboutDonationScreen extends StatelessWidget {
  const LearnAboutDonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Learn About Donation'),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1A1A2E),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.water_drop_rounded,
              size: 40,
              color: Color(0xFFC62828),
            ),
          ),

          SizedBox(height: 24),

          _buildArticleCard(
            context,
            icon: Icons.favorite_rounded,
            color: Color(0xFFC62828),
            title: 'Benefits of Blood Donation',
            description: 'Learn how donating helps your health and saves lives',
            content:
                'Blood donation has many health benefits including:\n\n'
                '1. Free health screening before each donation\n'
                '2. Reduced risk of heart disease\n'
                '3. Stimulates blood cell production\n'
                '4. Burns calories\n'
                '5. Saves up to 3 lives per donation\n\n'
                'Regular donors often report feeling a sense of purpose and improved well-being.',
          ),
          _buildArticleCard(
            context,
            icon: Icons.people_rounded,
            color: Color(0xFF1565C0),
            title: 'Who Can Donate?',
            description: 'Basic eligibility rules and safety information',
            content:
                'General eligibility requirements:\n\n'
                '1. Be at least 17 years old\n'
                '2. Weigh at least 50 kg (110 lbs)\n'
                '3. Be in good general health\n'
                '4. Have not donated in the last 56 days\n'
                '5. Not have certain medical conditions\n\n'
                'Always consult with the medical staff at the donation center for specific eligibility.',
          ),
          _buildArticleCard(
            context,
            icon: Icons.checklist_rounded,
            color: Color(0xFF2E7D32),
            title: 'How to Prepare',
            description: 'Simple steps to make your donation easier',
            content:
                'Before your donation:\n\n'
                '1. Drink plenty of water\n'
                '2. Eat a healthy meal\n'
                '3. Get a good night\'s sleep\n'
                '4. Wear comfortable clothing with sleeves that can be rolled up\n'
                '5. Bring a valid photo ID\n\n'
                'After your donation, rest for 10-15 minutes and enjoy a snack.',
          ),
          _buildArticleCard(
            context,
            icon: Icons.lightbulb_rounded,
            color: Color(0xFFF57C00),
            title: 'Common Myths',
            description: 'Clearing up fears and misunderstandings',
            content:
                'Common myths about blood donation:\n\n'
                'Myth: Donating blood is painful\n'
                'Fact: You may feel a brief pinch, but the process is mostly painless.\n\n'
                'Myth: I can get an infection from donating\n'
                'Fact: All equipment is sterile and used only once.\n\n'
                'Myth: Donating blood makes you weak\n'
                'Fact: Your body replenishes the blood within 24-48 hours.',
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required String content,
  }) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            content: SingleChildScrollView(
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Color(0xFF555555),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Color(0xFFC62828),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(18),
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
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
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
                  SizedBox(height: 3),
                  Text(
                    description,
                    style: TextStyle(fontSize: 13, color: Color(0xFF8E8E93)),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFCCCCCC),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
