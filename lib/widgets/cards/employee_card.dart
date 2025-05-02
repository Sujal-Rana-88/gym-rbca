import 'package:flutter/material.dart';

/// A card widget to display member details safely without null errors.
class EmployeeCard extends StatelessWidget {
  /// Expecting a map of user data where all values are strings (possibly empty).
  final Map<String, String> user;

  const EmployeeCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Build full name
    final firstName = user['firstName']?.trim() ?? '';
    final lastName = user['lastName']?.trim() ?? '';
    final name = (firstName.isNotEmpty || lastName.isNotEmpty)
        ? '$firstName ${lastName}'.trim()
        : 'Unknown';

    // Other fields with safe defaults
    final email = (user['userEmail']?.isNotEmpty == true) ? user['userEmail']! : 'Not provided';
    final fatherName = (user['fatherName']?.isNotEmpty == true) ? user['fatherName']! : 'Not provided';
    final countryCode = user['userCountryCode'] ?? '';
    final phoneNumber = user['userMobileNumber'] ?? '';
    final address = (user['userAddress']?.isNotEmpty == true) ? user['userAddress']! : 'Not provided';
    final status = user['status']?.toUpperCase() ?? 'UNKNOWN';
    final role = user['role']?.toUpperCase() ?? 'N/A';
    final gstin = user['organizationGstin'] ?? 'N/A';

    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 3)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 24,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            if (email.isNotEmpty) Text('📧 $email'),
            if (countryCode.isNotEmpty || phoneNumber.isNotEmpty)
              Text('📞 $countryCode $phoneNumber'),
            Text('👤 Father: $fatherName'),
            Text('🏠 Address: $address'),
            Text('🏷 Role: $role'),
          ],
        ),
      ),
    );
  }
}