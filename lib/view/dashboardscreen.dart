// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app/provider/auth_bloc.dart';

class DashboardScreen extends StatefulWidget {
  @override
_DashboardScreenState createState() => _DashboardScreenState();
}
class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVerification(context);
    });
  }

  void _checkVerification(BuildContext context) {
    final user = context.read<AuthBloc>().authProvider.user;
    if (user != null && user.verify.isEmpty) {
      _showVerificationDialog(context);
    }
  }

 void _showVerificationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Verifikasi data'),
          content: Text('User ini harus diverifikasi oleh atasan.'),
          actions: <Widget>[
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(LogoutEvent());
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Pegawai'),
        actions: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthUnauthenticated) {
                Navigator.of(context).pushReplacementNamed('/loginscreen');
              } else if (state is AuthError) {
                setState(() {
                  _isLoggingOut = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: _isLoggingOut
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () {
                      setState(() {
                        _isLoggingOut = true;
                      });
                      context.read<AuthBloc>().add(LogoutEvent());
                    },
                  ),
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to the Dashboard Pegawai Screen!'),
      ),
    );
  }
}