import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_rbca/blocs/auth/auth_bloc.dart';
import 'package:sample_rbca/blocs/role/role_bloc.dart';

class AppBlocProviders {
  static List<BlocProvider> providers = [
    BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
    BlocProvider<RoleBloc>(create: (_) => RoleBloc()), // Add more blocs here
  ];
}
