import 'package:flutter/material.dart';

class AddSubscription extends StatefulWidget {
  const AddSubscription({super.key});

  @override
  _AddSubscriptionState createState() => _AddSubscriptionState();
}

class _AddSubscriptionState extends State<AddSubscription> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> subscriptions = [
    {
      "package": "6_months",
      "title": "Half-Year Membership",
      "description": "Enjoy unlimited access for 6 months!",
      "user_id": "12323",
      "duration": 6,
      "Price": 123.0
    },
    {
      "package": "12_months",
      "title": "Annual Membership",
      "description": "Get a full year of premium features.",
      "user_id": "12324",
      "duration": 12,
      "Price": 200.0
    }
  ];

  final Map<String, dynamic> formData = {};

  void _addSubscription() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        subscriptions.add({
          "package": formData["package"] ?? "Custom Package",
          "title": formData["title"] ?? "No Title",
          "description": formData["description"] ?? "No Description",
          "user_id": formData["user_id"] ?? "Unknown",
          "duration": formData["duration"] ?? 1,
          "Price": formData["Price"] ?? 0.0,
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Subscription Added Successfully!"), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    }
  }

  Widget _buildTextField(String label, String key, {String? initialValue, TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white, // Consistent white background
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        keyboardType: type,
        validator: (value) => (value == null || value.isEmpty) ? 'Please enter $label' : null,
        onChanged: (value) => formData[key] = value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(), // Smooth scrolling
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Add Subscription", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                _buildTextField("Title", "title"),
                _buildTextField("Description", "description"),
                _buildTextField("Price", "Price", type: TextInputType.number),
                _buildTextField("Duration (Months)", "duration", type: TextInputType.number),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addSubscription,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                  child: Text("Add Subscription", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
