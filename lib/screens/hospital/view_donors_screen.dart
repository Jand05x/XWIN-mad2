import 'package:flutter/material.dart';

class ViewDonorsScreen extends StatelessWidget {
  const ViewDonorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Registered Donors'),
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
          _buildDonorCard('Ahmed Ali', 'A+', '0770 123 4567', true),
          _buildDonorCard('Sara Mohammed', 'O+', '0750 987 6543', true),
          _buildDonorCard('Jand Ayoub', 'B+', '0780 456 7890', false),
          _buildDonorCard('Layla Hassan', 'AB+', '0760 321 9876', true),
        ],
      ),
    );
  }

  Widget _buildDonorCard(
    String name,
    String bloodType,
    String phone,
    bool isAvailable,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
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
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 28,
                  color: Color(0xFF8E8E93),
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.water_drop_rounded,
                          size: 14,
                          color: Color(0xFFC62828),
                        ),
                        SizedBox(width: 4),
                        Text(
                          bloodType,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFC62828),
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(
                          Icons.phone_outlined,
                          size: 14,
                          color: Color(0xFF8E8E93),
                        ),
                        SizedBox(width: 4),
                        Text(
                          phone,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF8E8E93),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isAvailable ? Color(0xFFE8F5E9) : Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isAvailable ? 'Available' : 'Unavailable',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isAvailable ? Color(0xFF2E7D32) : Color(0xFF8E8E93),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isAvailable
                    ? Color(0xFFC62828)
                    : Color(0xFFE0E0E0),
                foregroundColor: isAvailable ? Colors.white : Color(0xFF8E8E93),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.call_rounded, size: 18),
              label: Text(
                'Contact Donor',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              onPressed: isAvailable ? () {} : null,
            ),
          ),
        ],
      ),
    );
  }
}
