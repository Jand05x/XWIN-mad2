import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Blood Requests screen
// Shows list of blood requests from hospitals, allows donating
class BloodRequestsScreen extends StatelessWidget {
  const BloodRequestsScreen({super.key});

  // Maps urgency text to a color
  Color _urgencyColor(String urgency) {
    switch (urgency) {
      case 'Urgent':
        return Color(0xFFC62828);
      case 'Within 24 hours':
        return Color(0xFF6A1B9A);
      default:
        return Color(0xFFF57C00); // Scheduled
    }
  }

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
      // Stream blood requests from Firestore in real-time
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('blood_requests')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Color(0xFFC62828)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong. Please try again.',
                style: TextStyle(color: Color(0xFF8E8E93)),
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];
          docs.sort((a, b) {
            final aTime = (a.data() as Map<String, dynamic>)['createdAt'] as Timestamp?;
            final bTime = (b.data() as Map<String, dynamic>)['createdAt'] as Timestamp?;
            if (aTime == null && bTime == null) return 0;
            if (aTime == null) return 1;
            if (bTime == null) return -1;
            return bTime.compareTo(aTime);
          });

          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.water_drop_outlined,
                    size: 64,
                    color: Color(0xFFBDBDBD),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No blood requests yet',
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

          return ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final docId = docs[index].id;

              final bloodType = data['bloodType'] ?? '';
              final hospital = data['hospital'] ?? 'Unknown Hospital';
              final urgency = data['urgency'] ?? 'Scheduled';
              final units = data['units'] ?? '1';
              final urgencyColor = _urgencyColor(urgency);

              return _buildRequestCard(
                context: context,
                docId: docId,
                bloodType: bloodType,
                hospital: hospital,
                urgency: urgency,
                units: '$units unit(s) needed',
                urgencyColor: urgencyColor,
              );
            },
          );
        },
      ),
    );
  }

  // Build a single request card
  Widget _buildRequestCard({
    required BuildContext context,
    required String docId,
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
          // Header row with blood type and urgency badge
          Row(
            children: [
              // Blood type circle
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
              // Urgency badge
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

          // Hospital location
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

          // Donate Now / Status button
          Row(
            children: [
              Expanded(
                child: _buildStatusButton(context, docId, urgencyColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build status-aware button based on user's response
  Widget _buildStatusButton(
    BuildContext context,
    String docId,
    Color urgencyColor,
  ) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return SizedBox(
        height: 46,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: urgencyColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: null,
          child: Text(
            'Sign in to donate',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('blood_requests')
          .doc(docId)
          .collection('responses')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return SizedBox(
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: urgencyColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _handleDonate(context, docId),
              child: Text(
                'Donate Now',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          );
        }

        final data = snap.data?.data() as Map<String, dynamic>?;
        final status = data?['status'] ?? '';

        if (status == 'pending') {
          return _statusBadge('Pending', Color(0xFFBDBDBD), Icons.hourglass_top_rounded);
        } else if (status == 'approved') {
          return _statusBadge('Accepted', Color(0xFF2E7D32), Icons.check_circle_rounded);
        } else if (status == 'denied') {
          return _statusBadge('Rejected', Color(0xFFC62828), Icons.cancel_rounded);
        }

        return SizedBox(
          height: 46,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: urgencyColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => _handleDonate(context, docId),
            child: Text(
              'Donate Now',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ),
        );
      },
    );
  }

  Widget _statusBadge(String text, Color color, IconData icon) {
    return SizedBox(
      height: 46,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: Icon(icon, size: 18),
        label: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        onPressed: null,
      ),
    );
  }

  // Handle donate button - register interest, points awarded only after hospital approves
  void _handleDonate(BuildContext context, String docId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final name = userDoc.data()?['name'] ?? 'Donor';
      final donorBloodType = userDoc.data()?['bloodType'] ?? '';
      final phone = userDoc.data()?['phone'] ?? '';

      await FirebaseFirestore.instance
          .collection('blood_requests')
          .doc(docId)
          .collection('responses')
          .doc(user.uid)
          .set({
        'userId': user.uid,
        'userName': name,
        'bloodType': donorBloodType,
        'phone': phone,
        'status': 'pending',
        'respondedAt': FieldValue.serverTimestamp(),
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Donation request sent! Waiting for hospital approval.'),
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
            content: Text('Failed to respond. Please try again.'),
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
