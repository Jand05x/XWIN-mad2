import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Events screen
// Shows list of upcoming donation events
class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  // Cycles through colors based on index so each card looks different
  Color _cardColor(int index) {
    final colors = [
      Color(0xFF1565C0),
      Color(0xFF2E7D32),
      Color(0xFFF57C00),
      Color(0xFF6A1B9A),
      Color(0xFFC62828),
    ];
    return colors[index % colors.length];
  }

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
      // Stream events from Firestore
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Still loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Color(0xFF1565C0)),
            );
          }

          // Firestore error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong. Please try again.',
                style: TextStyle(color: Color(0xFF8E8E93)),
              ),
            );
          }

          // No events yet
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_outlined,
                    size: 64,
                    color: Color(0xFFBDBDBD),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No events yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF8E8E93),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final docId = docs[index].id;
              final color = _cardColor(index);

              final title = data['title'] ?? 'Untitled Event';
              final date = data['date'] ?? '';
              final location = data['location'] ?? 'Unknown Location';
              final attendees = data['attendees'] ?? 0;

              return _buildEventCard(
                context: context,
                docId: docId,
                title: title,
                date: date,
                location: location,
                attendees: attendees,
                color: color,
              );
            },
          );
        },
      ),
    );
  }

  // Build a single event card
  Widget _buildEventCard({
    required BuildContext context,
    required String docId,
    required String title,
    required String date,
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
          // Header with icon and title
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

          // Event details
          _buildDetailRow(Icons.calendar_today_rounded, date, color),
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

          // RSVP button
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
              onPressed: () => _handleRsvp(context, docId),
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

  // Build a detail row with icon and text
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

  // Handle RSVP button - increment attendees and award points
  void _handleRsvp(BuildContext context, String docId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Increment the attendees count
      await FirebaseFirestore.instance.collection('events').doc(docId).update({
        'attendees': FieldValue.increment(1),
      });

      // Add points for attending event
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'points': FieldValue.increment(5),
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('RSVP confirmed! +5 points'),
            backgroundColor: Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to RSVP. Please try again.'),
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
