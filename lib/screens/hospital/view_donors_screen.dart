import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// View Donors screen
// Shows list of verified donors that hospitals can contact
class ViewDonorsScreen extends StatelessWidget {
  const ViewDonorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Registered Donors'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // Stream verified donors from Firestore
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'donor')
            .where('status', isEqualTo: 'verified')
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
                    'Failed to load donors.\n${snapshot.error}',
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

          final donors = snapshot.data?.docs ?? [];

          if (donors.isEmpty) {
            return const Center(
              child: Text(
                'No verified donors yet.',
                style: TextStyle(color: Color(0xFF8E8E93)),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: donors.length,
            itemBuilder: (context, index) {
              final data = donors[index].data() as Map<String, dynamic>;
              final name = data['name'] ?? 'Unknown';
              final bloodType = data['bloodType'] ?? '?';
              final phone = data['phone'] ?? '';
              final isAvailable = data['isAvailable'] ?? true;
              return _buildDonorCard(context, name, bloodType, phone, isAvailable);
            },
          );
        },
      ),
    );
  }

  // Build a single donor card
  Widget _buildDonorCard(
    BuildContext context,
    String name,
    String bloodType,
    String phone,
    bool isAvailable,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        children: [
          // Header row with avatar, name, blood type, phone
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 28,
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
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFC62828),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.phone_outlined,
                          size: 14,
                          color: Color(0xFF8E8E93),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          phone.isNotEmpty ? phone : 'No phone',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF8E8E93),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Availability badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isAvailable ? const Color(0xFFE8F5E9) : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isAvailable ? 'Available' : 'Unavailable',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isAvailable ? const Color(0xFF2E7D32) : const Color(0xFF8E8E93),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Contact Donor button (calls phone)
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isAvailable ? const Color(0xFFC62828) : const Color(0xFFE0E0E0),
                foregroundColor: isAvailable ? Colors.white : const Color(0xFF8E8E93),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.call_rounded, size: 18),
              label: const Text(
                'Contact Donor',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              onPressed: isAvailable && phone.isNotEmpty
                  ? () async {
                      final uri = Uri(scheme: 'tel', path: phone);
                      try {
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Could not call $phone'),
                                backgroundColor: const Color(0xFFC62828),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: const Color(0xFFC62828),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      }
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}