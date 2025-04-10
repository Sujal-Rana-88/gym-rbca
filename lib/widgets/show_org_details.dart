import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showOrgDetailsDialog(BuildContext context, Map<String, dynamic> organization) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        "Organization Details",
        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E88E5)),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow("Name", organization["name"]),
            _buildDetailRow("Email", organization["email"]),
            _buildDetailRow("Phone", "${organization["country_code"]} ${organization["phone"]}"),
            _buildDetailRow("Address", organization["address"]),
            _buildDetailRow("Total Members", "${organization["total_users"]}"),
            _buildDetailRow(
              "Subscription Ends",
              DateFormat('MMM dd, yyyy').format(organization["subscription_end_date"]),
            ),
            _buildDetailRow(
              "Joined Date",
              DateFormat('MMM dd, yyyy').format(organization["joined_date"]),
            ),
            SizedBox(height: 16),
            Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 4),
            Text(organization["description"], style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Close", style: TextStyle(color: Color(0xFF1E88E5))),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
  );
}

Widget _buildDetailRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$title: ", style: TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
