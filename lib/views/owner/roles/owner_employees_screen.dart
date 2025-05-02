import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
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

  // Organization static data (for org info dialog only)
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

  List<Map<String, dynamic>> users = [];
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadPermissions();
    _fetchEmployees(); // Directly fetch employees from API
  }

  Future<void> _loadPermissions() async {
    setState(() {
      _menuItems = ['Home', 'Roles'];
    });
  }

  Future<void> _fetchEmployees() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      // TODO: Replace with your real logic for acquiring the token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';
      final orgId = organization['org_id'];

      final dio = Dio();
      final response = await dio.get(
        'http://10.0.2.2:8081/api/users/getAll',
        queryParameters: {'orgId': orgId},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        // Make sure response.data['data'] is a List
        final allUsers = List<Map<String, dynamic>>.from(response.data['data']);
        // Only EMPLOYEE
        final employeeUsers = allUsers
            .where((u) => (u['role']?.toString()?.toUpperCase() ?? '') == 'EMPLOYEE')
            .toList();
        setState(() {
          users = employeeUsers;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load users';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch users: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AddRoleScreen(
        roles: ["Owner", "Employee"],
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
          Expanded(
            child: Builder(
              builder: (context) {
                if (isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (errorMessage.isNotEmpty) {
                  return Center(child: Text(errorMessage,
                      style: TextStyle(color: Colors.red)));
                } else if (users.isEmpty) {
                  return Center(child: Text("No employees found."));
                }
                // Search by name or email
                final filteredUsers = users.where((user) {
                  final name = (user['name'] ?? '').toLowerCase();
                  final email = (user['email'] ?? '').toLowerCase();
                  return name.contains(searchQuery) ||
                      email.contains(searchQuery);
                }).toList();

                if (filteredUsers.isEmpty) {
                  return Center(child: Text("No employees found for your search."));
                }

                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return EmployeeCard(
  user: user.map((key, value) => MapEntry(key, value?.toString() ?? '')),
);
                  },
                );
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

