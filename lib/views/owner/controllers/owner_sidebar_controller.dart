import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_rbca/blocs/role/role_bloc.dart';

class OwnerSidebarController {
  // 🔹 Singleton Instance
  static final OwnerSidebarController _instance = OwnerSidebarController._internal();

  factory OwnerSidebarController() {
    return _instance;
  }

  OwnerSidebarController._internal();

  int currentIndex = 0;

  void updateIndex(BuildContext context, int index, Function(int) setIndex) {
    setIndex(index); // Update state in UI

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/owner');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/gym/employee');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/gym/user');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/subscription/gym');
        break;
    }
  }
}
