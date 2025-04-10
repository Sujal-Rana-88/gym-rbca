import 'package:flutter/material.dart';
import 'package:sample_rbca/views/admin/orgs/add_org_subscription.dart';
import '../../../widgets/add_role_screen.dart';
import 'package:intl/intl.dart';

import '../../../widgets/cards/employee_card.dart';
import '../../../widgets/show_org_details.dart';
import '../../../widgets/cards/user_card.dart';

class OrgDetailsScreen extends StatefulWidget {
  final String orgId;

  OrgDetailsScreen({required this.orgId});

  @override
  _OrgDetailsScreenState createState() => _OrgDetailsScreenState();
}

class _OrgDetailsScreenState extends State<OrgDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String searchQuery = "";

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
  };

  final List<Map<String, String>> users = [
    {
      "user_id": "user_1",
      "name": "John Doe",
      "email": "john@example.com",
      "role": "Admin",
      "phone_number": "9876543210",
      "is_verified": "true"
    },
    {
      "user_id": "user_2",
      "name": "Jane Smith",
      "email": "jane@example.com",
      "role": "User",
      "phone_number": "1234567890",
      "is_verified": "false"
    },
    {
      "user_id": "user_3",
      "name": "Alice Brown",
      "email": "alice@example.com",
      "role": "Employee",
      "phone_number": "8765432109",
      "is_verified": "true"
    },
    {
      "user_id": "user_4",
      "name": "Bob Johnson",
      "email": "bob@example.com",
      "role": "User",
      "phone_number": "5678901234",
      "is_verified": "true"
    },
    {
      "user_id": "user_5",
      "name": "Carol White",
      "email": "carol@example.com",
      "role": "Admin",
      "phone_number": "4567890123",
      "is_verified": "true"
    },
    {
      "user_id": "user_6",
      "name": "David Black",
      "email": "david@example.com",
      "role": "Employee",
      "phone_number": "3456789012",
      "is_verified": "false"
    },
  ];

  final List<Map<String, dynamic>> subscriptions = [
    {
      "subscription_id": "sub_456",
      "package": "6 Months",
      "duration": 6,
      "price": 123.0,
      "title": "Basic Plan",
      "description": "Access to gym facilities for 6 months."
    },
    {
      "subscription_id": "sub_789",
      "package": "12 Months",
      "duration": 12,
      "price": 199.0,
      "title": "Annual Plan",
      "description": "Full-year access with additional benefits."
    },
    {
      "subscription_id": "sub_101",
      "package": "3 Months",
      "duration": 3,
      "price": 79.0,
      "title": "Quarterly Plan",
      "description": "Short-term gym access for 3 months."
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _showAddDialog() {
    if (_tabController.index == 0) {
      // Admin/Employee tab
      showDialog(
        context: context,
        builder: (context) => AddRoleScreen(
          roles: ["Owner", "Employee", "Manager"],
        ),
      );
    } else if (_tabController.index == 1) {
      // Users tab
      showDialog(
        context: context,
        builder: (context) => AddRoleScreen(
          roles: ["User"],
        ),
      );
    } else {
      // Subscriptions tab
      showDialog(context: context, builder: (context) => AddOrgSubscription());
    }
  }

  void _editSubscription(int index) async {
    final updatedSubscription = await showDialog(
      context: context,
      builder: (context) =>
          AddOrgSubscription(subscription: subscriptions[index]),
    );

    if (updatedSubscription != null) {
      setState(() {
        subscriptions[index] = updatedSubscription;
      });
    }
  }

  void _deleteSubscription(int index) {
    setState(() {
      subscriptions.removeAt(index);
    });
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build user list based on role filter
  Widget _buildUserList(List<String> roleFilter) {
    return Column(
      children: [
        // Search bar
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
        // Filtered user list
        Expanded(
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              if (roleFilter.contains(user["role"]) &&
                  (user["name"]!.toLowerCase().contains(searchQuery) ||
                      user["email"]!.toLowerCase().contains(searchQuery))) {
                return EmployeeCard(user: user);
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(organization["name"],
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
        bottom: TabBar(
          labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: "Owner/Employee"),
            Tab(text: "Users"),
            Tab(text: "Subscriptions"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Admin and Employee tab
          _buildUserList(["Admin", "Employee"]),

          // Users tab
          _buildUserList(["User"]),

          // Subscriptions tab
          ListView.builder(
            itemCount: subscriptions.length,
            itemBuilder: (context, index) {
              final subscription = subscriptions[index];
              return Container(
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 3))
                  ],
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    subscription["title"]!,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Text(subscription["description"]!),
                      Text("📆 Duration: ${subscription["duration"]} Months"),
                      Text("💰 Price: \$${subscription["price"]}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editSubscription(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Color(0xFF1E88E5)),
                        onPressed: () => _deleteSubscription(index),
                      ),
                    ],
                  ),
                ),
              );
            },
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
