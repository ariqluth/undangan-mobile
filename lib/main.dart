import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/app/service/api_service.dart';
import 'package:myapp/view/registerscreen.dart';
import 'package:provider/provider.dart';
import 'app/service/auth.dart';
import 'app/provider/auth_bloc.dart';
import 'app/provider/bottom_nav_bloc.dart';
import 'app/provider/management_user_block.dart';
import 'view/loginscreen.dart';
import 'view/homescreen.dart';
import 'view/dashboardscreen.dart';
import 'view/dashboardcustomerscreen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
         BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(context.read<AuthProvider>())..add(AutoLoginEvent()),
        ),
        BlocProvider<BottomNavBloc>(
          create: (context) => BottomNavBloc(),
        ),
        BlocProvider<ManagementUserBlock>(
          create: (context) => ManagementUserBlock(context.read<ApiService>()),
        ),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(context.read<AuthProvider>())..add(AutoLoginEvent()),
        child: MaterialApp(
          title: 'Wedding Check',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => AuthWrapper(),
            '/homescreen': (context) => HomeScreen(),
            '/dashboardscreen': (context) => DashboardScreen(),
            '/dashboardcustomerscreen': (context) => DashboardCustomerScreen(),
            '/loginscreen': (context) => LoginScreen(),
            '/registerscreen': (context) => RegisterScreen(),
          },
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticatedSuperAdmin) {
          Navigator.of(context).pushReplacementNamed('/homescreen');
        } else if (state is AuthAuthenticatedEmployee) {
          Navigator.of(context).pushReplacementNamed('/dashboardscreen');
        } else if (state is AuthAuthenticatedCustomer) {
          Navigator.of(context).pushReplacementNamed('/dashboardcustomerscreen');
        } else if (state is AuthUnauthenticated) {
          Navigator.of(context).pushReplacementNamed('/loginscreen');
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AuthError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('An error occurred: ${state.message}'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutEvent());
                      },
                      child: Text('Logout'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()), // Default loading screen
            );
          }
        },
      ),
    );
  }
}