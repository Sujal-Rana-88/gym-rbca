import 'package:flutter/material.dart';

import '../../../widgets/sidebar/sidebar.dart';
import '../admin_custom_sidebar.dart';
import '../controllers/admin_sidebar_controller.dart';

class DeleteOrg extends StatefulWidget {
  const DeleteOrg({super.key});

  @override
  _DeleteOrgState createState() => _DeleteOrgState();
}

class _DeleteOrgState extends State<DeleteOrg> {
  final List<Map<String, String>> organizations = [
    {
      "org_id": "org_123",
      "name": "XYZ Gym",
      "email": "contact@xyzgym.com",
      "country_code": "+91",
      "phone": "1234567890",
      "address": "123 Gym Street"
    },
    {
      "org_id": "org_456",
      "name": "ABC Fitness",
      "email": "info@abcfitness.com",
      "country_code": "+1",
      "phone": "9876543210",
      "address": "456 Fitness Lane"
    }
  ];

  void _showDeleteConfirmationDialog(String orgId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this organization?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  organizations.removeWhere((org) => org["org_id"] == orgId);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Organization deleted successfully!")),
                );
              },
              child: const Text("Delete", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 2;
    final AdminSidebarController _sidebarController = AdminSidebarController();
    return Scaffold(
      drawer: AdminCustomSidebar(
        currentIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: organizations.length,
          itemBuilder: (context, index) {
            final org = organizations[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(org["name"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Email: ${org["email"]}\nPhone: ${org["country_code"]} ${org["phone"]}"),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteConfirmationDialog(org["org_id"]!),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
