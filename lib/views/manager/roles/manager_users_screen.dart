import 'package:flutter/material.dart';
import 'package:sample_rbca/widgets/cards/user_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/add_role_screen.dart';
import '../../../widgets/cards/employee_card.dart';
import '../../../widgets/show_org_details.dart';
import '../../owner/custom_drawer.dart';
import '../manager_custom_drawer.dart';

class ManagerUsersScreen extends StatefulWidget {
  @override
  _ManagerUsersScreenState createState() => _ManagerUsersScreenState();
}

class _ManagerUsersScreenState extends State<ManagerUsersScreen> {
  String searchQuery = "";
  int _currentIndex = 2;
  final Map<String, dynamic> organization = {
    "org_id": "org_123",
    "name": "XYZ Gym",
    "email": "contact@xyzgym.com",
    "country_code": "+91",
    "phone": "1234567890",
    "address": "123 Gym Street",
    "subscription_end_date": DateTime.now().add(Duration(days: 30)),
    "total_users": 25,
    "joined_date": DateTime.now().subtract(Duration(days: 365)),
    "description":
        "A premium fitness center with state-of-the-art equipment and certified trainers."
  };
  @override
  void initState() {
    super.initState();
  }



  final List<Map<String, String>> users = [
    {
      "user_id": "user_1",
      "name": "John Doe",
      "email": "john@example.com",
      "subscription_end_date": "24.05.2025",
      "country_code": "+91",
      "phone_number": "9876543210",
      "address"  : "jalandhar, Punjab"
    },
    {
      "user_id": "user_2",
      "name": "Jane Smith",
      "email": "jane@example.com",
      "subscription_end_date": "24.05.2025",
      "country_code": "+91",
      "phone_number": "1234567890",
      "address"  : "jalandhar, Punjab"
    },
    {
      "user_id": "user_3",
      "name": "Alice Brown",
      "email": "alice@example.com",
      "subscription_end_date": "24.05.2025",
      "country_code": "+91",
      "phone_number": "8765432109",
      "address"  : "jalandhar, Punjab"
    },
  ];

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AddRoleScreen(
        roles: ["User"],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ManagerCustomDrawer(
        currentIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Users",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Search by name or email...",
                prefixIcon: Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                if (user["name"]!.toLowerCase().contains(searchQuery) ||
                    user["email"]!.toLowerCase().contains(searchQuery)) {
                  return UserCard(user: user);
                }
                return Container();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Color(0xFF1E88E5),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
