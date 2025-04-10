part of 'role_bloc.dart';

abstract class RoleEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddRoleRequested extends RoleEvent {
  final String email;
  final String firstName;
  final String lastName;
  final String address;
  final String userMobileNumber;
  final String userCountryCode;
  final String role;

  AddRoleRequested({required this.firstName,required this.lastName,required this.address,required this.userMobileNumber,required this.userCountryCode,required this.role, required this.email});
}

class AuthLogoutEvent extends RoleEvent {}
