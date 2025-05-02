import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sample_rbca/views/admin/orgs/add_org_subscription.dart';
import '../../../widgets/add_role_screen.dart';
import 'package:intl/intl.dart';
import '../../../widgets/cards/employee_card.dart';
import '../../../widgets/show_org_details.dart';
import '../../../widgets/cards/user_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrgDetailsScreen extends StatefulWidget {
  final String orgId;

  OrgDetailsScreen({required this.orgId});

  @override
  _OrgDetailsScreenState createState() => _OrgDetailsScreenState();
}

class _OrgDetailsScreenState extends State<OrgDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String searchQuery = "";
  late Dio _dio;
  List<dynamic> users = [];
  List<dynamic> subscriptions = [];

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _dio = Dio();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';

    try {
      // Fetch users
      final userResponse = await _dio.get(
        'http://10.0.2.2:8081/api/users/getAll',
        queryParameters: {'organizationId': widget.orgId},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Send as Bearer token
          },
        ),
      );

      if (userResponse.statusCode == 200) {
        setState(() {
          users = userResponse.data['data'];
        });
      }

      // Fetch subscriptions
      final subscriptionResponse = await _dio.get(
        'http://10.0.2.2:8081/api/subscription/getAll', 
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Send as Bearer token
          },
        ),
      );

      if (subscriptionResponse.statusCode == 200) {
        setState(() {
          subscriptions = subscriptionResponse.data['data'];
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
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
      builder: (context) => AddOrgSubscription(subscription: subscriptions[index]),
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

  Widget _buildUserList(List<String> roleFilter) {
    return Column(
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
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              if (user != null &&
                  roleFilter.contains(user["role"]) &&
                  (user["firstName"]?.toLowerCase().contains(searchQuery) ?? false ||
                   user["userEmail"]?.toLowerCase().contains(searchQuery) ?? false)) {
                return UserCard(user: user); // Custom card widget
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
        title: Text(organization["name"] ?? "Organization Details", 
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
          _buildUserList(["OWNER", "MANAGER", "EMPLOYEE"]),
          // Users tab
          _buildUserList(["MEMBER"]),
          // Subscriptions tab
          ListView.builder(
            itemCount: subscriptions.length,
            itemBuilder: (context, index) {
              final subscription = subscriptions[index];
              if (subscription != null) {
                return Container(
                  margin: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 3))
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      subscription["subscriptionType"] ?? "No Title",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(subscription["description"] ?? "No Description"),
                        Text("📆 Duration: ${subscription["duration"] ?? 0} Months"),
                        Text("💰 Price: \$${subscription["price"] ?? 0}"),
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
              }
              return Container(); // Prevent layout issues if subscription is null
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
