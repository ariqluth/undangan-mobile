import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/app/provider/bottom_nav_bloc.dart';
import 'package:myapp/app/provider/profile/profile_bloc.dart';
import 'package:myapp/view/fragment/employee/orderemployee_screen.dart';
import 'package:myapp/view/fragment/employee/orderlist_screen.dart';
import 'package:myapp/view/fragment/employee/orderverifyemployee_screen.dart';
import 'package:myapp/view/fragment/profile_screen.dart';
import 'package:myapp/view/profile/profile_screen.dart';
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

  Future<void> _checkVerification(BuildContext context) async {
    final user = context.read<AuthBloc>().authProvider.user;
    if (user != null) {
      // Check if email is verified
      if (user.verify == null || user.verify.isEmpty) {
        _showEmailVerificationDialog(context);
        return;
      }

      // Check if profile is complete
      if (user.verify.isEmpty) {
        final profile = await context.read<ProfileBloc>().apiService.showProfile(user.id, user.token);
        final isProfileComplete = profile.username.isNotEmpty && profile.alamat.isNotEmpty && profile.nomer_telepon.isNotEmpty;
        if (!isProfileComplete) {
          _showVerificationStepper(context, user.id);
        }
      }
    }
  }

  void _showVerificationStepper(BuildContext context, int userId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: ProfileVerificationStepper(userId: userId),
        );
      },
    );
  }

  void _showEmailVerificationDialog(BuildContext context) {
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
      body: BlocConsumer<BottomNavBloc, BottomNavState>(
        listener: (context, state) {
          if (state is BottomNavItemSelectedState && state.index == 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Navigated to Management User')),
            );
          }
          if (state is BottomNavItemSelectedState && state.index == 2) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Navigated to Management Undangan Item List')),
            );
          }
          if (state is BottomNavItemSelectedState && state.index == 3) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Navigated to Profile')),
            );
          }
        },
        builder: (context, state) {
          if (state is BottomNavItemSelectedState) {
            switch (state.index) {
              case 0:
                return Center(child: Text('Home Screen'));
              case 1:
                final user = context.read<AuthBloc>().authProvider.user;
                return ShowProfileScreen(userId: user!.id);
              case 2:
                return ShowVerifyProfileScreen();
              case 3:
                final user = context.read<AuthBloc>().authProvider.user;
                return ShowVerifyProfilePetugasScreen(userId: user!.id);
              case 4:
                final user = context.read<AuthBloc>().authProvider.user;
                return ShowOrderlistScreen(userId: user!.id);
              default:
                return Center(child: Text('Home Screen'));
            }
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Home Screen'),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: state is BottomNavItemSelectedState ? state.index : 0,
            onTap: (index) {
              context.read<BottomNavBloc>().add(BottomNavItemSelected(index));
            },
            selectedItemColor: Colors.blue, // Color for selected item
            unselectedItemColor: Colors.black, // Color for unselected items
            showUnselectedLabels: true, // Show labels for unselected items
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Order',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'VerifyOrder',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'ListOrder',
              ),
            ],
          );
        },
      ),
    );
  }
}
