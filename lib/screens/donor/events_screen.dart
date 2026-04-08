import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Donation Events'),
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
          _buildEventCard(
            context: context,
            title: 'Community Blood Drive',
            date: 'Nov 15, 2025',
            time: '8:00 AM',
            location: 'Shiryan Medical Center',
            attendees: 45,
            color: Color(0xFF1565C0),
          ),
          _buildEventCard(
            context: context,
            title: 'Health Awareness Day',
            date: 'Nov 22, 2025',
            time: '10:00 AM',
            location: 'KRO Street',
            attendees: 32,
            color: Color(0xFF2E7D32),
          ),
          _buildEventCard(
            context: context,
            title: 'Hospital Campaign',
            date: 'Dec 5, 2025',
            time: '9:00 AM',
            location: 'Central Hospital',
            attendees: 28,
            color: Color(0xFFF57C00),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard({
    required BuildContext context,
    required String title,
    required String date,
    required String time,
    required String location,
    required int attendees,
    required Color color,
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
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.event_rounded, color: color, size: 24),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          _buildDetailRow(
            Icons.calendar_today_rounded,
            '$date at $time',
            color,
          ),
          SizedBox(height: 8),
          _buildDetailRow(
            Icons.location_on_outlined,
            location,
            Color(0xFF8E8E93),
          ),
          SizedBox(height: 8),
          _buildDetailRow(
            Icons.people_outline_rounded,
            '$attendees people attending',
            Color(0xFF2E7D32),
          ),

          SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('RSVP confirmed!'),
                    backgroundColor: Color(0xFF2E7D32),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              child: Text(
                'RSVP',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: Color(0xFF555555)),
          ),
        ),
      ],
    );
  }
}
