import 'package:flutter/material.dart';

class BloodRequestsScreen extends StatelessWidget {
  const BloodRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Blood Requests'),
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
          _buildRequestCard(
            context: context,
            bloodType: 'A+',
            hospital: 'Central Hospital',
            urgency: 'Urgent',
            units: '2 units needed',
            urgencyColor: Color(0xFFC62828),
          ),
          _buildRequestCard(
            context: context,
            bloodType: 'O-',
            hospital: 'City Medical Center',
            urgency: 'Within 24 hrs',
            units: '3 units needed',
            urgencyColor: Color(0xFF6A1B9A),
          ),
          _buildRequestCard(
            context: context,
            bloodType: 'B+',
            hospital: 'Regional Hospital',
            urgency: 'Scheduled',
            units: '1 unit needed',
            urgencyColor: Color(0xFFF57C00),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard({
    required BuildContext context,
    required String bloodType,
    required String hospital,
    required String urgency,
    required String units,
    required Color urgencyColor,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: urgencyColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    bloodType,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: urgencyColor,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$bloodType Blood Needed',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      units,
                      style: TextStyle(fontSize: 13, color: Color(0xFF8E8E93)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: urgencyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  urgency,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: urgencyColor,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 14),

          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Color(0xFF8E8E93),
              ),
              SizedBox(width: 6),
              Text(
                hospital,
                style: TextStyle(fontSize: 13, color: Color(0xFF8E8E93)),
              ),
            ],
          ),

          SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: urgencyColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Thank you for volunteering!'),
                    backgroundColor: Color(0xFF2E7D32),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              child: Text(
                'Donate Now',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
