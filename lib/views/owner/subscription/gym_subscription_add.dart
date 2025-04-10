// import 'package:flutter/material.dart';
// import '../../../widgets/sidebar/sidebar.dart';
// import '../controllers/owner_sidebar_controller.dart';
// import '../manager_custom_drawer.dart';
//
// class GymSubscriptionAdd extends StatefulWidget {
//   const GymSubscriptionAdd({super.key});
//
//   @override
//   _GymSubscriptionAddState createState() => _GymSubscriptionAddState();
// }
//
// class _GymSubscriptionAddState extends State<GymSubscriptionAdd> {
//   final List<Map<String, dynamic>> subscriptions = [
//     {
//       "package": "6_months",
//       "user_id": "12323", // Static admin ID
//       "duration": 1,
//       "Price": 123.0
//     },
//     {
//       "package": "12_months",
//       "user_id": "12324", // Another static user ID
//       "duration": 2,
//       "Price": 200.0
//     }
//   ];
//
//   String? _selectedPackage;
//   String? _userId;
//   double? _price;
//   int _duration = 1;
//   int _currentIndex = 4;
//   final OwnerSidebarController _sidebarController = OwnerSidebarController();
//   bool isAdmin(String userId) {
//     return userId == "12323";
//   }
//
//   void _addSubscription() {
//     if (_userId != null && isAdmin(_userId!)) {
//       setState(() {
//         subscriptions.add({
//           "package": _selectedPackage!,
//           "user_id": _userId!,
//           "duration": _duration,
//           "Price": _price!,
//         });
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Subscription Added Successfully!"),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Only Admin can add subscriptions!"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             SizedBox(height: 10),
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: "User ID",
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 filled: true,
//                 fillColor: Colors.blueAccent.withOpacity(0.1),
//               ),
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 _userId = value;
//               },
//             ),
//             SizedBox(height: 10),
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: "Price",
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 filled: true,
//                 fillColor: Colors.blueAccent.withOpacity(0.1),
//               ),
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 _price = double.tryParse(value);
//               },
//             ),
//             SizedBox(height: 10),
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: "Duration (Months)",
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 filled: true,
//                 fillColor: Colors.blueAccent.withOpacity(0.1),
//               ),
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 _duration = int.tryParse(value) ?? 1;
//               },
//             ),
//             SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: _addSubscription,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                 ),
//                 child: Text("Add Subscription", style: TextStyle(fontSize: 16, color: Colors.white)),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text("Subscriptions List:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: subscriptions.length,
//                 itemBuilder: (context, index) {
//                   final subscription = subscriptions[index];
//                   return Card(
//                     color: Colors.blueAccent.withOpacity(0.1),
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     child: ListTile(
//                       title: Text(subscription['package'], style: TextStyle(fontWeight: FontWeight.bold)),
//                       subtitle: Text(
//                         "User ID: ${subscription['user_id']}\nDuration: ${subscription['duration']} months\nPrice: \$${subscription['Price']}",
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }