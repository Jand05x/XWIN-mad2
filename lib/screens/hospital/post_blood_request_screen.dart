import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostBloodRequestScreen extends StatefulWidget {
  const PostBloodRequestScreen({super.key});

  @override
  _PostBloodRequestScreenState createState() => _PostBloodRequestScreenState();
}

class _PostBloodRequestScreenState extends State<PostBloodRequestScreen> {
  final TextEditingController unitsController = TextEditingController();
  final TextEditingController hospitalController = TextEditingController();
  String? selectedBloodType;
  String? selectedUrgency;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Post Blood Request'),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1A1A2E),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Color(0xFFFCE4EC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.water_drop_rounded,
                color: Color(0xFFC62828),
                size: 28,
              ),
            ),

            SizedBox(height: 20),

            Text(
              'Request Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Fill in blood request information',
              style: TextStyle(fontSize: 14, color: Color(0xFF8E8E93)),
            ),

            SizedBox(height: 28),

            _buildLabel('Blood Type'),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButtonFormField<String>(
                initialValue: selectedBloodType,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.water_drop_outlined,
                    color: Color(0xFF8E8E93),
                    size: 22,
                  ),
                ),
                hint: Text(
                  'Select blood type',
                  style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 15),
                ),
                items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => selectedBloodType = value),
              ),
            ),

            SizedBox(height: 18),

            _buildLabel('Hospital Name'),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: hospitalController,
                decoration: InputDecoration(
                  hintText: 'Enter hospital name',
                  hintStyle: TextStyle(color: Color(0xFFBDBDBD), fontSize: 15),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.local_hospital_outlined,
                    color: Color(0xFF8E8E93),
                    size: 22,
                  ),
                ),
              ),
            ),

            SizedBox(height: 18),

            _buildLabel('Number of Units'),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: unitsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter number of units',
                  hintStyle: TextStyle(color: Color(0xFFBDBDBD), fontSize: 15),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.format_list_numbered_rounded,
                    color: Color(0xFF8E8E93),
                    size: 22,
                  ),
                ),
              ),
            ),

            SizedBox(height: 18),

            _buildLabel('Urgency Level'),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButtonFormField<String>(
                initialValue: selectedUrgency,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.priority_high_rounded,
                    color: Color(0xFF8E8E93),
                    size: 22,
                  ),
                ),
                hint: Text(
                  'Select urgency',
                  style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 15),
                ),
                items: ['Urgent', 'Within 24 hours', 'Scheduled']
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (value) => setState(() => selectedUrgency = value),
              ),
            ),

            SizedBox(height: 36),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFC62828),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: isLoading ? null : _submitRequest,
                child: isLoading
                    ? SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        'Post Request',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF333333),
      ),
    );
  }

  void _submitRequest() async {
    // Validate all fields
    if (selectedBloodType == null ||
        hospitalController.text.trim().isEmpty ||
        unitsController.text.trim().isEmpty ||
        selectedUrgency == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Write the request to Firestore blood_requests collection
      await FirebaseFirestore.instance.collection('blood_requests').add({
        'bloodType': selectedBloodType,
        'hospital': hospitalController.text.trim(),
        'units': unitsController.text.trim(),
        'urgency': selectedUrgency,
        'postedBy': FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Request posted successfully!'),
            backgroundColor: Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to post request. Please try again.'),
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

  @override
  void dispose() {
    unitsController.dispose();
    hospitalController.dispose();
    super.dispose();
  }
}
