import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewDonorsScreen extends StatelessWidget {
  const ViewDonorsScreen({super.key});

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Donation Responses'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('blood_requests')
            .where('postedBy', isEqualTo: _uid)
            .snapshots(),
        builder: (context, requestsSnapshot) {
          if (requestsSnapshot.hasError) {
            return const Center(
              child: Text('Failed to load responses.',
                  style: TextStyle(color: Color(0xFF8E8E93))),
            );
          }
          if (requestsSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFC62828)),
            );
          }

          final requests = requestsSnapshot.data?.docs ?? [];
          if (requests.isEmpty) {
            return const Center(
              child: Text('No blood requests posted yet.',
                  style: TextStyle(color: Color(0xFF8E8E93))),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final reqData = requests[index].data() as Map<String, dynamic>;
              final reqId = requests[index].id;
              final bloodType = reqData['bloodType'] ?? '?';
              final hospital = reqData['hospital'] ?? 'Unknown';
              final urgency = reqData['urgency'] ?? '';

              return _buildRequestSection(
                context,
                requestId: reqId,
                bloodType: bloodType,
                hospital: hospital,
                urgency: urgency,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRequestSection(
    BuildContext context, {
    required String requestId,
    required String bloodType,
    required String hospital,
    required String urgency,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8F8),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFFE0E0)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFC62828),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    bloodType,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$bloodType at $hospital',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    Text(
                      urgency,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildPendingResponses(requestId, bloodType, hospital),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPendingResponses(
    String requestId,
    String bloodType,
    String hospital,
  ) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('blood_requests')
          .doc(requestId)
          .collection('responses')
          .where('status', isEqualTo: 'pending')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Failed to load responses.',
                style: TextStyle(color: Color(0xFF8E8E93))),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFC62828)),
          );
        }

        final responses = snapshot.data?.docs ?? [];
        responses.sort((a, b) {
          final aTime = (a.data() as Map<String, dynamic>)['respondedAt'] as Timestamp?;
          final bTime = (b.data() as Map<String, dynamic>)['respondedAt'] as Timestamp?;
          if (aTime == null && bTime == null) return 0;
          if (aTime == null) return 1;
          if (bTime == null) return -1;
          return bTime.compareTo(aTime);
        });
        if (responses.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text('No pending responses.',
                  style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 13)),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: responses.length,
          itemBuilder: (context, index) {
            final data = responses[index].data() as Map<String, dynamic>;
            final docId = responses[index].id;
            final name = data['userName'] ?? 'Unknown';
            final donorBloodType = data['bloodType'] ?? '?';
            final phone = data['phone'] ?? '';
            final respondedAt = data['respondedAt'] as Timestamp?;
            final timeStr = respondedAt != null
                ? _formatTime(respondedAt.toDate())
                : 'Just now';

            return _buildResponseCard(
              requestId: requestId,
              responseDocId: docId,
              donorUid: data['userId'] ?? '',
              name: name,
              bloodType: donorBloodType,
              phone: phone,
              time: timeStr,
              requestBloodType: bloodType,
              hospital: hospital,
            );
          },
        );
      },
    );
  }

  Widget _buildResponseCard({
    required String requestId,
    required String responseDocId,
    required String donorUid,
    required String name,
    required String bloodType,
    required String phone,
    required String time,
    required String requestBloodType,
    required String hospital,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 26,
                  color: Color(0xFF8E8E93),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.water_drop_rounded,
                          size: 14,
                          color: Color(0xFFC62828),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          bloodType,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFC62828),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.phone_outlined,
                          size: 12,
                          color: Color(0xFF8E8E93),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          phone.isNotEmpty ? phone : 'No phone',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8E8E93),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFFBDBDBD),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.check_rounded, size: 18),
                    label: const Text(
                      'Approve',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    onPressed: () => _handleApprove(
                      requestId,
                      responseDocId,
                      donorUid,
                      name,
                      bloodType,
                      hospital,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFC62828),
                      side: const BorderSide(
                        color: Color(0xFFC62828),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.close_rounded, size: 18),
                    label: const Text(
                      'Deny',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    onPressed: () => _handleDeny(
                      requestId,
                      responseDocId,
                      donorUid,
                      name,
                      bloodType,
                      hospital,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleApprove(
    String requestId,
    String responseDocId,
    String donorUid,
    String name,
    String bloodType,
    String hospital,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('blood_requests')
          .doc(requestId)
          .collection('responses')
          .doc(responseDocId)
          .update({'status': 'approved'});

      await FirebaseFirestore.instance
          .collection('users')
          .doc(donorUid)
          .update({
        'points': FieldValue.increment(5),
        'donations': FieldValue.increment(1),
      });

      await FirebaseFirestore.instance
          .collection('notifications')
          .add({
        'userId': donorUid,
        'title': 'Donation Request Approved!',
        'message':
            'Your donation request for $bloodType at $hospital has been approved. +5 points awarded!',
        'type': 'approved',
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
      });
    } catch (e) {
      debugPrint('Error approving donor: $e');
    }
  }

  Future<void> _handleDeny(
    String requestId,
    String responseDocId,
    String donorUid,
    String name,
    String bloodType,
    String hospital,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('blood_requests')
          .doc(requestId)
          .collection('responses')
          .doc(responseDocId)
          .update({'status': 'denied'});

      await FirebaseFirestore.instance
          .collection('notifications')
          .add({
        'userId': donorUid,
        'title': 'Donation Request Not Approved',
        'message':
            'Your donation request for $bloodType at $hospital was not approved this time.',
        'type': 'denied',
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
      });
    } catch (e) {
      debugPrint('Error denying donor: $e');
    }
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
