import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_rbca/routes/routes.dart';
import 'package:sample_rbca/utils/bloc_providers.dart'; 



void main(){
  runApp(
    MultiBlocProvider(
      providers: AppBlocProviders.providers,
      child: MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Role-Based Access Control',

      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashScreen,
      routes: AppRoutes.routes,
    );
  }
}
