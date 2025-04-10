import 'package:flutter/material.dart';
import '../../widgets/show_org_details.dart';
import 'controllers/owner_sidebar_controller.dart';
import 'custom_drawer.dart';

class OwnerScreen extends StatefulWidget {
  @override
  _OwnerScreenState createState() => _OwnerScreenState();
}

class _OwnerScreenState extends State<OwnerScreen> {
  final OwnerSidebarController _sidebarController = OwnerSidebarController();
  int _currentIndex = 0;
  int userCount = 150;
  int reportCount = 45;

  final Map<String, dynamic> organization = {
    "name": "Iron Gym",
    "email": "info@irongym.com",
    "phone": "9876543210",
    "country_code": "+91",
    "address": "123 Muscle Street, Fit City",
    "total_users": 150,
    "subscription_end_date": DateTime(2025, 12, 31),
    "joined_date": DateTime(2023, 6, 15),
    "description": "Iron Gym is the ultimate fitness destination for strength training and conditioning. Join us to transform your body and mind!",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF1E88E5),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => showOrgDetailsDialog(context, organization),
            tooltip: "Organization Details",
          ),
        ],
      ),
      drawer: CustomDrawer(
        currentIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: Column(
        children: [
          // Expanded(
          //   child: GymUsersScreen(orgId: 'your_org_id'),
          // ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }


  Widget _buildCounterBox(String title, int count, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 120,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 3,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$count',
              style: const TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
