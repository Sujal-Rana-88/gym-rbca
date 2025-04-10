import 'package:flutter/material.dart';

class AddUserOwnerScreen extends StatefulWidget {
  final List<String> roles;

  const AddUserOwnerScreen({super.key, required this.roles});

  @override
  _AddUserOwnerScreenState createState() => _AddUserOwnerScreenState();
}

class _AddUserOwnerScreenState extends State<AddUserOwnerScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> formData = {
    "name": "",
    "email": "",
    "country_code": "+91",
    "phone_number": "",
    "address": "",
    "role": "",
    "father_name": "",
  };

  @override
  void initState() {
    super.initState();
    formData["role"] = widget.roles.isNotEmpty ? widget.roles[0] : "User"; // Default role
  }

  Widget _buildTextField(String label, String key, {String? initialValue}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.blueAccent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        onChanged: (value) {
          formData[key] = value;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        constraints: const BoxConstraints(maxHeight: 500),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Register User",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildTextField("Name", "name"),
                _buildTextField("Email", "email"),
                _buildTextField("Country Code", "country_code", initialValue: "+91"),
                _buildTextField("Phone Number", "phone_number"),
                _buildTextField("Address", "address"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<String>(
                    value: formData["role"],
                    decoration: InputDecoration(
                      labelText: "Select Role",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: widget.roles.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        formData["role"] = value!;
                      });
                    },
                  ),
                ),
                _buildTextField("Father's Name", "father_name"),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("User Registered Successfully!"),
                          backgroundColor: Colors.blueAccent,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Register", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}