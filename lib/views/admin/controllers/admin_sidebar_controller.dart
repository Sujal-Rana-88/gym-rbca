import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_rbca/blocs/admin/admin_bloc.dart';

class AdminSidebarController {
  //! Singleton Instance
  static final AdminSidebarController _instance = AdminSidebarController._internal();

  factory AdminSidebarController() {
    return _instance;
  }

  AdminSidebarController._internal();

  int currentIndex = 0;

  void updateIndex(BuildContext context, int index, Function(int) setIndex) {
    setIndex(index);

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/admin');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/org');
        BlocProvider(
          create: (context) => AdminBloc(),
        );
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/subscription');
        BlocProvider(
          create: (context) => AdminBloc(),
        );
        break;
    }
  }
}
