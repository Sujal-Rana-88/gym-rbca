import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final Map<String, dynamic> user; // Use dynamic type to allow mixed types

  const UserCard({Key? key, required this.user}) : super(key: key);

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
          (user["firstName"]?.toString() ?? 'No first name') +
              ' ' +
              (user["lastName"]?.toString() ??
                  'No last name'), // Concatenate first and last name
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text("📧 ${user["userEmail"]?.toString() ?? 'No email'}"),
            Text(
                "📞 ${user["userCountryCode"]?.toString() ?? ''} ${user["phone_number"]?.toString() ?? 'No phone number'}"),
            Text("🏷 Role: ${user["role"]?.toString() ?? 'No role'}"),
            Text(
                "✅ Subscription End Date: ${user["subscription_end_date"]?.toString() ?? 'No end date'}"),
            Text(
                "🏘️ Address: ${user["userAddress"]?.toString() ?? 'No address'}"),
          ],
        ),
      ),
    );
  }
}
