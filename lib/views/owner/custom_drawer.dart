import 'package:flutter/material.dart';
import '../../../widgets/sidebar/sidebar.dart';
import 'controllers/owner_sidebar_controller.dart';

class CustomDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  CustomDrawer({required this.currentIndex, required this.onItemSelected});

  final OwnerSidebarController _sidebarController = OwnerSidebarController();

  @override
  Widget build(BuildContext context){
    return Sidebar(
      menuItems: ['Home', 'Employees', 'Users', 'Subscriptions'],
      selectedIndex: currentIndex,
      onItemSelected: (index) {
        _sidebarController.updateIndex(context, index, (newIndex) {
          onItemSelected(newIndex);
        });
      },
    );
  }
}