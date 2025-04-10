import 'package:flutter/material.dart';

import '../buttons/logout_button.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({
    super.key,
    required this.menuItems,
    required this.onItemSelected,
    required this.selectedIndex,
  });

  final List<String> menuItems;
  final Function(int) onItemSelected;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: const Text(
              'Welcome',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  title: Text(
                    menuItems[index],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: selectedIndex == index ? Colors.blueAccent : Colors.black87,
                    ),
                  ),
                  trailing: selectedIndex == index
                      ? const Icon(Icons.circle, size: 8, color: Colors.blueAccent)
                      : null,
                  onTap: () => onItemSelected(index),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: LogoutButton(),
            ),
          ),
        ],
      ),
    );
  }
}
