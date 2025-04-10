import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/add_role_screen.dart';
import '../../../widgets/cards/employee_card.dart';
import '../../../widgets/show_org_details.dart';
import '../../owner/custom_drawer.dart';
import '../manager_custom_drawer.dart';

class ManagerEmployeesScreen extends StatefulWidget {
  @override
  _ManagerEmployeesScreenState createState() => _ManagerEmployeesScreenState();
}

class _ManagerEmployeesScreenState extends State<ManagerEmployeesScreen> {
  String searchQuery = "";
  String selectedRole = "All";
  int _currentIndex = 1;
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
      "role": "Employee",
      "phone_number": "9876543210",
      "country_code": "+91",
      "is_verified": "true"
    },
    {
      "user_id": "user_3",
      "name": "Alice Brown",
      "email": "alice@example.com",
      "role": "Employee",
      "phone_number": "8765432109",
      "country_code": "+91",
      "is_verified": "true"
    },
  ];

  void _showAddDialog() {
      showDialog(
        context: context,
        builder: (context) => AddRoleScreen(
          roles: ["Employee"],
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
        title: Text("Employees",
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
                  return EmployeeCard(user: user);
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
