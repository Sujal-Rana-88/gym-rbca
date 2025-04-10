import 'package:flutter/material.dart';

class AddOrgSubscription extends StatefulWidget {
  final Map<String, dynamic>? subscription;

  const AddOrgSubscription({super.key, this.subscription});

  @override
  _AddOrgSubscriptionState createState() => _AddOrgSubscriptionState();
}

class _AddOrgSubscriptionState extends State<AddOrgSubscription> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};

  @override
  void initState() {
    super.initState();
    if (widget.subscription != null) {
      formData.addAll(widget.subscription!);
    }
  }

  void _saveSubscription() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, formData);
    }
  }

  Widget _buildTextField(String label, String key, {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: formData[key]?.toString() ?? '',
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white, // Best color for input background
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        keyboardType: type,
        validator: (value) => (value == null || value.isEmpty) ? 'Please enter $label' : null,
        onChanged: (value) {
          setState(() {
            formData[key] = (type == TextInputType.number) ? double.tryParse(value) ?? value : value;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.white, // Best card color
      elevation: 10, // Adds a slight shadow for a premium look
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.subscription == null ? "Add Subscription" : "Edit Subscription",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildTextField("Title", "title"),
              _buildTextField("Description", "description"),
              _buildTextField("Price", "price", type: TextInputType.number),
              _buildTextField("Duration (Months)", "duration", type: TextInputType.number),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveSubscription,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: Text(
                  widget.subscription == null ? "Add Subscription" : "Save Changes",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
