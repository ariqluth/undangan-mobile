// bloc/auth_state.dart
part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}
class AuthAuthenticatedSuperAdmin extends AuthState {
  final User user;

  AuthAuthenticatedSuperAdmin(this.user);

  @override
  List<Object> get props => [user];
}

class AuthAuthenticatedCustomer extends AuthState {
  final User user;

  AuthAuthenticatedCustomer(this.user);

  @override
  List<Object> get props => [user];
}

class AuthAuthenticatedEmployee extends AuthState {
  final User user;

  AuthAuthenticatedEmployee(this.user);

  @override
  List<Object> get props => [user];
}

class AuthAuthenticated extends AuthState {
  final User user;

  AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object> get props => [message];
}