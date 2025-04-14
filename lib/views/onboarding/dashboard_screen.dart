import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), _navigateBasedOnAuth);
  }

  void _navigateBasedOnAuth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance(); // Await the Future here

    String? accessToken = prefs.getString('access_token');
    String? role = prefs.getString('role');
    String? expString = prefs.getString('exp');

    print("Token: $accessToken");
    print("Role: $role");
    print("Exp: $expString");


    if (accessToken != null && expString != null) {
      int expTime = int.parse(expString) * 1000;
      int currentTime = DateTime.now().millisecondsSinceEpoch;

      if (currentTime < expTime) {
        switch (role) {
          case 'ROLE_ADMIN':
            Navigator.pushReplacementNamed(context, '/admin');
            return;
          case 'ROLE_ORGANIZATION':
            Navigator.pushReplacementNamed(context, '/owner');
            return;
          case 'ROLE_MANAGER':
            Navigator.pushReplacementNamed(context, '/employee');
            return;
        }
      } else {
        await prefs.clear(); // Clear SharedPreferences if the token is expired
      }
    }

    Navigator.pushReplacementNamed(context, '/login');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your logo here
            Icon(
              Icons.star,
              size: 100,
              color: Color(0xFFDC2626),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to My App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFDC2626), // Preferred color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
