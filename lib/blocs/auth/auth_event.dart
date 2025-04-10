part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested({required this.email, required this.password});
}
class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String userName;
  final String firstName;
  final String lastName;

  SignUpRequested({required this.email, required this.password, required this.userName, required this.firstName, required this.lastName});
}
class AuthLogoutEvent extends AuthEvent {}
