import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  final Map<String, String> subscription;

  const SubscriptionCard({Key? key, required this.subscription}) : super(key: key);

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
          subscription["title"]!,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text("📧 ${subscription["email"]}"),
            Text("📞 ${subscription["country_code"]} ${subscription["phone_number"]}"),
            Text("🏷 Role: ${subscription["role"]}"),
            Text("✅ Verified: ${subscription["is_verified"] == "true" ? "Yes" : "No"}"),
          ],
        ),
      ),
    );
  }
}
