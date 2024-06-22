// bloc/auth_event.dart
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String role;
  final String device;

  RegisterEvent(this.name, this.email, this.password, this.role, this.device);

  @override
  List<Object> get props => [name, email, password, role, device];
}

class LogoutEvent extends AuthEvent {}

class AutoLoginEvent extends AuthEvent {}