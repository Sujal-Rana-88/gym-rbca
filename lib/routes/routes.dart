import 'package:flutter/material.dart';
import 'package:sample_rbca/views/admin/orgs/org_screen.dart';
import 'package:sample_rbca/views/admin/orgs/delete_org.dart';
import 'package:sample_rbca/views/admin/subscriptions/subscription_screen.dart';
import 'package:sample_rbca/views/manager/roles/manager_users_screen.dart';
import 'package:sample_rbca/views/owner/owner_screen.dart';
import 'package:sample_rbca/views/onboarding/dashboard_screen.dart';
import 'package:sample_rbca/views/onboarding/login_screen.dart';
import 'package:sample_rbca/views/owner/subscription/app_subscription.dart';
import 'package:sample_rbca/views/owner/subscription/gym_subscription_add.dart';
import '../views/manager/manager_screen.dart';
import '../views/manager/roles/manager_employees_screen.dart';
import '../views/owner/roles/owner_employees_screen.dart';
import '../views/owner/roles/owner_users_screen.dart';
import '../views/owner/subscription/gym_subscription_screen.dart';

class AppRoutes {
  static const String splashScreen = '/splashscreen';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String admin = '/admin';
  static const String owner = '/owner';
  static const String manager = '/manager';
  static const String user = '/user';
  static const String addUserAdminScreen = '/add/user';
  static const String org = '/org';
  static const String deleteOrg = '/deleteOrg';
  static const String deleteSubscription = '/subscription/delete';
  static const String gymUserScreen = '/gym/user';
  static const String gymEmployeeScreen = "/gym/employee";
  static const String managerEmployeeScreen = "/manager/employee";
  static const String managerUserScreen = "/manager/user";
  static const String addSubscription = '/subscription/add';
  static const String gymSubscription = '/subscription/gym';
  static const String gymSubscriptionAdd = '/subscription/add/gym';
  static const String userSubscriptionDetails = '/subscription/userdetails';
  static const String subscription = '/subscription';
  static const String buySubscription = '/subscription/buy';

  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => DashboardScreen(),
    login: (context) => LoginScreen(),
    dashboard: (context) => DashboardScreen(),
    gymEmployeeScreen: (context) => OwnerEmployeesScreen(),
    gymUserScreen: (context) => OwnerUsersScreen(),
    subscription: (context) => SubscriptionScreen(),
    admin: (context) => const OrgScreen(),
    owner: (context) => OwnerScreen(),
    manager: (context) => ManagerScreen(),
    org: (context) => const OrgScreen(),
    gymSubscription: (context) => const GymSubscriptionScreen(),
    deleteOrg: (context) => const DeleteOrg(),
    buySubscription: (context) => const AppSubscription(),
    managerEmployeeScreen: (context) =>  ManagerEmployeesScreen(),
    managerUserScreen: (context) =>  ManagerUsersScreen(),
  };
}
