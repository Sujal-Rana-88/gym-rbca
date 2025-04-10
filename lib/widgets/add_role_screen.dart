import 'package:flutter/material.dart';

class AddRoleScreen extends StatefulWidget {
  final List<String> roles;

  const AddRoleScreen({super.key, required this.roles});

  @override
  _AddRoleScreenState createState() => _AddRoleScreenState();
}

class _AddRoleScreenState extends State<AddRoleScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {
    "name": "",
    "email": "",
    "country_code": "+91",
    "phone_number": "",
    "address": "",
    "role": "",
    "father_name": "",
  };

  List<String> filteredRoles = [];

  @override
  void initState() {
    super.initState();
    // Include all provided roles, including "Manager"
    filteredRoles = widget.roles.toList();
    formData["role"] = filteredRoles.isNotEmpty ? filteredRoles.first : "";
  }

  Widget _buildTextField(String label, String key, {String? initialValue}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (value) => (value == null || value.isEmpty) ? 'Please enter $label' : null,
          onChanged: (value) => formData[key] = value,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          constraints: const BoxConstraints(maxHeight: 600),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Register User", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildTextField("Name", "name"),
                  _buildTextField("Email", "email"),
                  _buildTextField("Country Code", "country_code", initialValue: "+91"),
                  _buildTextField("Phone Number", "phone_number"),
                  _buildTextField("Address", "address"),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: DropdownButtonFormField<String>(
                      value: filteredRoles.contains(formData["role"]) ? formData["role"] : null,
                      decoration: InputDecoration(
                        labelText: "Select Role",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: filteredRoles.map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
                      onChanged: (value) => setState(() => formData["role"] = value!),
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
                            backgroundColor: Color(0xFF1E88E5),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1E88E5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Register", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
