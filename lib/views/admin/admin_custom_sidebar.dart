import 'package:flutter/material.dart';
import 'package:sample_rbca/views/admin/controllers/admin_sidebar_controller.dart';
import '../../../widgets/sidebar/sidebar.dart';

class AdminCustomSidebar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  AdminCustomSidebar({required this.currentIndex, required this.onItemSelected});

  final AdminSidebarController _sidebarController = AdminSidebarController();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        iconTheme: IconThemeData(color: Colors.white), // Set the icon color to white here
      ),
      child: Sidebar(
        menuItems: ['Home', 'Organizations', 'Subscriptions'],
        selectedIndex: currentIndex,
        onItemSelected: (index){
          _sidebarController.updateIndex(context, index, (newIndex){
            onItemSelected(newIndex);
          });
        },
      ),
    );
  }
}
