import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sample_rbca/widgets/buttons/logout_button.dart';
import 'package:sample_rbca/widgets/sidebar/sidebar.dart';
import 'controllers/manager_sidebar_controller.dart';
import 'manager_custom_drawer.dart';

class ManagerScreen extends StatefulWidget {
  @override
  _ManagerScreenState createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  final ManagerSidebarController _sidebarController =
      ManagerSidebarController();
  int _currentIndex = 0;
  List<String> _menuItems = ['Home', 'Employees', 'Users'];

  final List<Widget> _pages = [
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Employee Dashboard"),
          SizedBox(height: 20),
          Text("✅ Manage Users"),
          Text("✅ View Reports"),
          SizedBox(height: 20),
          LogoutButton()
        ],
      ),
    ),
    // AddUserEmployeeScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadPermissions();
  }

  Future<void> _loadPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? permissions = prefs.getStringList('permissions');

    setState(() {
      _menuItems = ['Home', 'Roles']; // Always include Home and Roles
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Manager Panel',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      drawer: ManagerCustomDrawer(
        currentIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _pages[_currentIndex],
    );
  }
}
