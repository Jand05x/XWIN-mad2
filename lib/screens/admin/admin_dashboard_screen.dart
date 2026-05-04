import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(
                child: _buildLiveStatCard(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('role', isEqualTo: 'donor')
                      .snapshots(),
                  label: 'Total Donors',
                  icon: Icons.people_rounded,
                  color: const Color(0xFFF57C00),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildLiveStatCard(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('role', isEqualTo: 'hospital')
                      .snapshots(),
                  label: 'Hospitals',
                  icon: Icons.local_hospital_rounded,
                  color: const Color(0xFF1565C0),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          const Text(
            'Management',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),

          const SizedBox(height: 14),

          _buildVerifyDonorsTile(context),
          _buildActionTile(
            context,
            title: 'Manage Hospitals',
            subtitle: 'View and manage hospital accounts',
            icon: Icons.local_hospital_rounded,
            color: const Color(0xFF1565C0),
            onTap: () => _showHospitalsDialog(context),
          ),
          _buildActionTile(
            context,
            title: 'View Blood Requests',
            subtitle: 'Monitor all active requests',
            icon: Icons.water_drop_rounded,
            color: const Color(0xFFC62828),
            onTap: () => _showBloodRequestsDialog(context),
          ),
          _buildActionTile(
            context,
            title: 'View Donation Events',
            subtitle: 'All scheduled donation events',
            icon: Icons.event_rounded,
            color: const Color(0xFF2E7D32),
            onTap: () => _showEventsDialog(context),
          ),
          _buildActionTile(
            context,
            title: 'System Statistics',
            subtitle: 'View platform analytics',
            icon: Icons.bar_chart_rounded,
            color: const Color(0xFF6A1B9A),
            onTap: () => _showSystemStatsDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveStatCard({
    required Stream<QuerySnapshot> stream,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _statCardShell(
            child: const Icon(Icons.error_outline, color: Color(0xFFC62828)),
            label: label,
            color: color,
            icon: icon,
          );
        }
        final count = snapshot.data?.docs.length ?? 0;
        return _statCardShell(
          child: snapshot.connectionState == ConnectionState.waiting
              ? SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(color: color, strokeWidth: 2.5),
                )
              : Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
          label: label,
          color: color,
          icon: icon,
        );
      },
    );
  }

  Widget _statCardShell({
    required Widget child,
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          child,
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Color(0xFF8E8E93)),
          ),
        ],
      ),
    );
  }

  void _showBloodRequestsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _FirestoreListDialog(
        title: 'Blood Requests',
        icon: Icons.water_drop_rounded,
        color: const Color(0xFFC62828),
        stream: FirebaseFirestore.instance
            .collection('blood_requests')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        itemBuilder: (data) =>
            '${data['bloodType'] ?? '?'} — ${data['hospital'] ?? 'Unknown'} (${data['urgency'] ?? ''})',
      ),
    );
  }

  void _showEventsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _FirestoreListDialog(
        title: 'Donation Events',
        icon: Icons.event_rounded,
        color: const Color(0xFF2E7D32),
        stream: FirebaseFirestore.instance
            .collection('events')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        itemBuilder: (data) =>
            '${data['title'] ?? 'Event'} — ${data['location'] ?? 'Unknown'}',
      ),
    );
  }

  void _showHospitalsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _FirestoreListDialog(
        title: 'Hospitals',
        icon: Icons.local_hospital_rounded,
        color: const Color(0xFF1565C0),
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'hospital')
            .snapshots(),
        itemBuilder: (data) => '${data['name'] ?? 'Hospital'} — ${data['email'] ?? ''}',
      ),
    );
  }

  void _showSystemStatsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.bar_chart_rounded, color: Color(0xFF6A1B9A), size: 22),
            SizedBox(width: 8),
            Text('System Statistics',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatRow(
              'Total Donors',
              FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: 'donor')
                  .snapshots(),
              const Color(0xFFC62828),
            ),
            const SizedBox(height: 10),
            _buildStatRow(
              'Total Hospitals',
              FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: 'hospital')
                  .snapshots(),
              const Color(0xFF1565C0),
            ),
            const SizedBox(height: 10),
            _buildStatRow(
              'Blood Requests',
              FirebaseFirestore.instance
                  .collection('blood_requests')
                  .snapshots(),
              const Color(0xFFF57C00),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close',
                style: TextStyle(
                    color: Color(0xFF6A1B9A), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, Stream<QuerySnapshot> stream, Color color) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snap) {
        final count = snap.data?.docs.length ?? 0;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 14, color: Color(0xFF333333))),
            snap.connectionState == ConnectionState.waiting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : snap.hasError
                    ? const Icon(Icons.error_outline,
                        color: Color(0xFFC62828), size: 18)
                    : Text(
                        count.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: color),
                      ),
          ],
        );
      },
    );
  }

  Widget _buildVerifyDonorsTile(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'donor')
          .where('verificationStatus', isEqualTo: 'pending')
          .snapshots(),
      builder: (context, snapshot) {
        final pendingCount = snapshot.data?.docs.length ?? 0;
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/verify'),
          child: Container(
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
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC62828).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.verified_user_rounded, color: Color(0xFFC62828), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Verify Donors',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        pendingCount > 0
                            ? '$pendingCount pending approval'
                            : 'No pending verifications',
                        style: const TextStyle(fontSize: 13, color: Color(0xFF8E8E93)),
                      ),
                    ],
                  ),
                ),
                if (pendingCount > 0)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC62828),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      pendingCount.toString(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                    ),
                  ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFCCCCCC),
                  size: 22,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF8E8E93)),
                  ),
                ],
              ),
            ),
            const Icon(
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

// Reusable dialog that streams a Firestore collection and lists items
class _FirestoreListDialog extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Stream<QuerySnapshot> stream;
  final String Function(Map<String, dynamic> data) itemBuilder;

  const _FirestoreListDialog({
    required this.title,
    required this.icon,
    required this.color,
    required this.stream,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 8),
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: StreamBuilder<QuerySnapshot>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: Color(0xFFC62828)));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFC62828)),
              );
            }
            final docs = snapshot.data?.docs ?? [];
            if (docs.isEmpty) {
              return const Text('No records found.',
                  style: TextStyle(color: Color(0xFF8E8E93)));
            }
            return ListView.separated(
              shrinkWrap: true,
              itemCount: docs.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final data = docs[i].data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    itemBuilder(data),
                    style: const TextStyle(fontSize: 13, color: Color(0xFF333333)),
                  ),
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close',
              style: TextStyle(color: color, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}