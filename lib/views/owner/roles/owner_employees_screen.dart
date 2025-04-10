import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/add_role_screen.dart';
import '../../../widgets/cards/employee_card.dart';
import '../../../widgets/show_org_details.dart';
import '../custom_drawer.dart';

class OwnerEmployeesScreen extends StatefulWidget {
  @override
  _OwnerEmployeesScreenState createState() => _OwnerEmployeesScreenState();
}

class _OwnerEmployeesScreenState extends State<OwnerEmployeesScreen> {
  String searchQuery = "";
  String selectedRole = "All";
  int _currentIndex = 1;
  List<String> _menuItems = ['Home', 'Roles'];
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
    _loadPermissions();
  }

  Future<void> _loadPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? permissions = prefs.getStringList('permissions');

    setState(() {
      _menuItems = ['Home', 'Roles']; // Always include Home and Roles

    });
  }
  final List<Map<String, String>> users = [
    {
      "user_id": "user_1",
      "name": "John Doe",
      "email": "john@example.com",
      "role": "Owner",
      "phone_number": "9876543210",
      "country_code": "+91",
      "is_verified": "true"
    },
    {
      "user_id": "user_2",
      "name": "Jane Smith",
      "email": "jane@example.com",
      "role": "Owner",
      "phone_number": "1234567890",
      "country_code": "+91",
      "is_verified": "false"
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
          roles: ["Owner",  "Employee"],
        ),
      );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
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
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedRole,
              items: ["All", "Owner","Employee"].map((role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRole = value!;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index]; // Get the individual user
                if ((selectedRole == "All" || user["role"] == selectedRole) &&
                    (user["name"]!.toLowerCase().contains(searchQuery) ||
                        user["email"]!.toLowerCase().contains(searchQuery))) {
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
