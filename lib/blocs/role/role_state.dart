part of 'role_bloc.dart';

abstract class RoleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RoleInitial extends RoleState {}
class RoleLoading extends RoleState {}

class RoleCreated extends RoleState {
  final String message;

  RoleCreated({required this.message});

  @override
  List<Object?> get props => [message];
}

class RoleError extends RoleState {
  final String message;
  RoleError(this.message);

  @override
  List<Object?> get props => [message];
}
