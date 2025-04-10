part of 'admin_bloc.dart';

abstract class AdminState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminSuccess extends AdminState {
  final String message;
  AdminSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminFailure extends AdminState {
  final String error;
  AdminFailure(this.error);

  @override
  List<Object?> get props => [error];
}
