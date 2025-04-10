import 'package:flutter/material.dart';
import '../admin_custom_sidebar.dart';
import '../../../widgets/add_subscription.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final List<Map<String, dynamic>> subscriptions = [
    {
      "package": "6_months",
      "title": "Half-Year Membership",
      "description": "Enjoy unlimited access for 6 months!",
      "user_id": "12323",
      "duration": 6,
      "Price": 123.0,
    },
    {
      "package": "12_months",
      "title": "Annual Membership",
      "description": "Get a full year of premium features.",
      "user_id": "12324",
      "duration": 12,
      "Price": 200.0,
    },
  ];
  int _currentIndex = 2;

  bool isAdmin(String userId) {
    return userId == "12323";
  }

  void _deleteSubscription(String userId, String package) {
      setState(() {
        subscriptions.removeWhere(
                (sub) => sub['user_id'] == userId && sub['package'] == package);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Subscription Deleted Successfully!")),
      );

  }

  void _editSubscription(String userId, String package) {
    final subscription = subscriptions.firstWhere(
          (sub) => sub['user_id'] == userId && sub['package'] == package,
      orElse: () => {},
    );

    if (subscription.isEmpty) return;

    TextEditingController titleController =
    TextEditingController(text: subscription['title']);
    TextEditingController descriptionController =
    TextEditingController(text: subscription['description']);
    TextEditingController priceController =
    TextEditingController(text: subscription['Price'].toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Subscription"),
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Price",
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                double? newPrice = double.tryParse(priceController.text);
                if (newPrice == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invalid Price Entered!")),
                  );
                  return;
                }

                setState(() {
                  subscription['title'] = titleController.text;
                  subscription['description'] = descriptionController.text;
                  subscription['Price'] = newPrice;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Subscription Updated Successfully!")),
                );

                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );

      },
    );
  }

  void _showDeleteConfirmationDialog(String userId, String package) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this subscription?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteSubscription(userId, package);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminCustomSidebar(
        currentIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      appBar: AppBar(
        title: const Text(
          "Subscriptions",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF1E88E5),
        toolbarHeight: 80, // Increased height
      ),
      body: Container(
        color: Colors.white,
        child: Padding(

          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(

            itemCount: subscriptions.length,
            itemBuilder: (context, index) {
              final subscription = subscriptions[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  title: Text(
                    subscription['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(subscription['description'], style: TextStyle(color: Colors.grey[700])),
                      const SizedBox(height: 5),
                      Text("Duration: ${subscription['duration']} months"),
                      Text("Price: \$${subscription['Price']}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _editSubscription(subscription['user_id'], subscription['package']);
                        },
                        tooltip: "Edit Subscription",
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteConfirmationDialog(subscription['user_id'], subscription['package']);
                        },
                        tooltip: "Delete Subscription",
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const AddSubscription(),
        ),
        backgroundColor: const Color(0xFF1E88E5),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}