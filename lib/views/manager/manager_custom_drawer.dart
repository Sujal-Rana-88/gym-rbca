import 'package:flutter/material.dart';
import '../../../widgets/sidebar/sidebar.dart';
import 'controllers/manager_sidebar_controller.dart';

class ManagerCustomDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  ManagerCustomDrawer({required this.currentIndex, required this.onItemSelected});

  final ManagerSidebarController _sidebarController = ManagerSidebarController();

  @override
  Widget build(BuildContext context){
    return Sidebar(
      menuItems: ['Home', 'Employees', 'Users'],
      selectedIndex: currentIndex,
      onItemSelected: (index) {
        _sidebarController.updateIndex(context, index, (newIndex) {
          onItemSelected(newIndex);
        });
      },
    );
  }
}