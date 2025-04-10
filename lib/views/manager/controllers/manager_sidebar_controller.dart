import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_rbca/blocs/role/role_bloc.dart';

class ManagerSidebarController {
  //! Singleton Instance
  static final ManagerSidebarController _instance = ManagerSidebarController._internal();

  factory ManagerSidebarController() {
    return _instance;
  }

  ManagerSidebarController._internal();

  int currentIndex = 0;

  void updateIndex(BuildContext context, int index, Function(int) setIndex) {
    setIndex(index);

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/manager');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/manager/employee');
      case 2:
        Navigator.pushReplacementNamed(context, '/manager/user');
    }
  }
}
