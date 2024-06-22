// bloc/auth_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/user.dart';
import '../service/auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';


 class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthProvider authProvider;

  AuthBloc(this.authProvider) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        await authProvider.login(event.email, event.password);
        if (authProvider.user!.roles.contains('super-admin')) {
          emit(AuthAuthenticatedSuperAdmin(authProvider.user!));
        } else if (authProvider.user!.roles.contains('employee')) {
          emit(AuthAuthenticatedEmployee(authProvider.user!));
        } else if (authProvider.user!.roles.contains('customer')) {
          emit(AuthAuthenticatedCustomer(authProvider.user!));
        } else {
          emit(AuthError('Unknown role'));
        }
      } catch (e) {
        print('Login Error: $e');
        emit(AuthError(e.toString()));
      }
    });

  on<RegisterEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        await authProvider.register(event.name, event.email, event.password, event.role, event.device);
        emit(AuthAuthenticated(authProvider.user!));
      } catch (e) {
        print('Register Error: $e');
        emit(AuthError(e.toString()));
      }
    });

 on<LogoutEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        await authProvider.logout();
        emit(AuthUnauthenticated());
      } catch (e) {
        print('Logout Error: $e');
        emit(AuthError(e.toString()));
      }
    });

     on<AutoLoginEvent>((event, emit) async {
      emit(AuthLoading());
      await authProvider.tryAutoLogin();
      if (authProvider.user != null) {
        if (authProvider.user!.roles.contains('super-admin')) {
          emit(AuthAuthenticatedSuperAdmin(authProvider.user!));
        } else if (authProvider.user!.roles.contains('employee')) {
          emit(AuthAuthenticatedEmployee(authProvider.user!));
        } else {
          emit(AuthError('Unknown role'));
        }
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }
}