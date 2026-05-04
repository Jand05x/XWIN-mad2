import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Verification Queue screen
// Allows admins to approve/reject donor registrations
class VerificationQueueScreen extends StatelessWidget {
  const VerificationQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Verification Queue'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // Stream pending donor verifications from Firestore
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'donor')
            .where('verificationStatus', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Color(0xFFC62828), size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Failed to load queue.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF8E8E93)),
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFC62828)),
            );
          }

          final pending = snapshot.data?.docs ?? [];

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Count badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.pending_rounded,
                        color: Color(0xFFF57C00),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${pending.length} Pending Verification${pending.length == 1 ? '' : 's'}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF57C00),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // No pending verifications
                if (pending.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No pending verifications.',
                        style: TextStyle(color: Color(0xFF8E8E93)),
                      ),
                    ),
                  )
                else
                  // List of pending verifications
                  Expanded(
                    child: ListView.builder(
                      itemCount: pending.length,
                      itemBuilder: (context, index) {
                        final doc = pending[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final name = data['name'] ?? 'Unknown';
                        final bloodType = data['bloodType'] ?? '?';
                        final createdAt = data['createdAt'] as Timestamp?;
                        final dateStr = createdAt != null
                            ? _formatDate(createdAt.toDate())
                            : 'Unknown date';
                        return _buildVerificationCard(
                          context,
                          docId: doc.id,
                          name: name,
                          bloodType: bloodType,
                          date: dateStr,
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Format date helper
  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  // Build verification card
  Widget _buildVerificationCard(
    BuildContext context, {
    required String docId,
    required String name,
    required String bloodType,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
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
          // Header row with avatar, name, blood type, date
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
                        const SizedBox(width: 14),
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 12,
                          color: Color(0xFF8E8E93),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          date,
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
            ],
          ),

          const SizedBox(height: 14),

          // Documents section (placeholder)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                _buildDocRow(Icons.badge_rounded, 'ID: verified_id.jpg'),
                const SizedBox(height: 6),
                _buildDocRow(Icons.camera_alt_rounded, 'Selfie: selfie.jpg'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Approve/Reject buttons
          Row(
            children: [
              // Approve button
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _updateStatus(context, docId, 'verified'),
                    child: const Text(
                      'Approve',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Reject button
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFC62828),
                      side: const BorderSide(color: Color(0xFFC62828), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _updateStatus(context, docId, 'rejected'),
                    child: const Text(
                      'Reject',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
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

  // Update donor verification status
  Future<void> _updateStatus(
    BuildContext context,
    String docId,
    String status,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(docId)
           .update({'verificationStatus': status});

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(status == 'verified' ? 'Donor approved!' : 'Donor rejected.'),
            backgroundColor: status == 'verified'
                ? const Color(0xFF2E7D32)
                : const Color(0xFF555555),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update status: $e'),
            backgroundColor: const Color(0xFFC62828),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  // Build document row
  Widget _buildDocRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF8E8E93)),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF555555))),
      ],
    );
  }
}