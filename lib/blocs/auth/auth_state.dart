part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}

class AccountCreated extends AuthState {
  final String message;

  AccountCreated({required this.message});

  @override
  List<Object?> get props => [message];
}
class Authenticated extends AuthState {
  final String email;

  Authenticated({required this.email});

  @override
  List<Object?> get props => [email];
}

// class AuthAuthenticated extends AuthState {
//   final String userRole;
//   AuthAuthenticated(this.userRole);
//
//   @override
//   List<Object?> get props => [userRole];
// }

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
class SignUpError extends AuthState {
  final String message;

  SignUpError({required this.message});

  @override
  List<Object?> get props => [message];
}