import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 180,
              floating: false,
              pinned: true,
              backgroundColor: Color(0xFFD32F2F),
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.notifications_rounded),
                  onPressed: () => Navigator.pushNamed(context, '/notifications'),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, User!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF212121)),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: _buildStatCard('12', 'Donations', Icons.favorite_rounded, Color(0xFFD32F2F))),
                        SizedBox(width: 15),
                        Expanded(child: _buildStatCard('240', 'Points', Icons.star_rounded, Color(0xFFFFA726))),
                      ],
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Quick Actions',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF212121)),
                    ),
                    SizedBox(height: 15),
                    _buildActionCard(context, 'Blood Requests', 'Find people who need your help', Icons.bloodtype_rounded, Color(0xFFD32F2F), '/requests'),
                    _buildActionCard(context, 'Donation Events', 'Join upcoming events', Icons.event_rounded, Color(0xFF1976D2), '/events'),
                    _buildActionCard(context, 'Learn More', 'About blood donation', Icons.menu_book_rounded, Color(0xFF7B1FA2), '/learn'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          SizedBox(height: 12),
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 13, color: Color(0xFF757575))),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, String subtitle, IconData icon, Color color, String route) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 13, color: Color(0xFF757575))),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF9E9E9E)),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}