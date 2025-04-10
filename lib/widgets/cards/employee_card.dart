import 'package:flutter/material.dart';

class EmployeeCard extends StatelessWidget {
  final Map<String, String> user;

  const EmployeeCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          user["name"]!,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text("📧 ${user["email"]}"),
            Text("📞 ${user["country_code"]} ${user["phone_number"]}"),
            Text("🏷 Role: ${user["role"]}"),
            Text("✅ Verified: ${user["is_verified"] == "true" ? "Yes" : "No"}"),
          ],
        ),
      ),
    );
  }
}
