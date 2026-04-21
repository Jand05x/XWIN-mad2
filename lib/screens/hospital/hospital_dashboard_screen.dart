import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HospitalDashboardScreen extends StatefulWidget {
  const HospitalDashboardScreen({super.key});

  @override
  State<HospitalDashboardScreen> createState() => _HospitalDashboardScreenState();
}

class _HospitalDashboardScreenState extends State<HospitalDashboardScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Hospital Dashboard'),
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
                      .collection('bloodRequests')
                      .where('hospitalId', isEqualTo: _uid)
                      .where('status', isEqualTo: 'active')
                      .snapshots(),
                  label: 'Active Requests',
                  icon: Icons.water_drop_rounded,
                  color: const Color(0xFFC62828),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildLiveStatCard(
                  stream: FirebaseFirestore.instance
                      .collection('events')
                      .where('hospitalId', isEqualTo: _uid)
                      .snapshots(),
                  label: 'Events Planned',
                  icon: Icons.event_rounded,
                  color: const Color(0xFF1565C0),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          const Text(
            'Hospital Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),

          const SizedBox(height: 14),

          _buildActionTile(
            context,
            title: 'Post Blood Request',
            subtitle: 'Create a new blood request',
            icon: Icons.water_drop_rounded,
            color: const Color(0xFFC62828),
            onTap: () => Navigator.pushNamed(context, '/post_request'),
          ),
          _buildActionTile(
            context,
            title: 'Create Event',
            subtitle: 'Organize a donation drive',
            icon: Icons.event_rounded,
            color: const Color(0xFF1565C0),
            onTap: () => Navigator.pushNamed(context, '/create_event'),
          ),
          _buildActionTile(
            context,
            title: 'View Donors',
            subtitle: 'See registered donors',
            icon: Icons.people_rounded,
            color: const Color(0xFFF57C00),
            onTap: () => Navigator.pushNamed(context, '/view_donors'),
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
                  child: CircularProgressIndicator(
                    color: color,
                    strokeWidth: 2.5,
                  ),
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