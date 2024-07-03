import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/app/models/profile.dart';
import 'package:myapp/app/provider/auth_bloc.dart';
import 'package:myapp/app/provider/bottom_nav_bloc.dart';
import 'package:myapp/app/provider/management_user_block.dart';
import 'package:myapp/app/provider/profile/profile_bloc.dart';
import 'package:myapp/app/provider/profile/profile_event.dart';
import 'package:myapp/view/fragment/customer/ordercustomer_screen.dart';
import 'package:myapp/view/fragment/profile_screen.dart';
import 'package:myapp/view/fragment/visitoritem_screen.dart';

class DashboardCustomerScreen extends StatefulWidget {
  @override
  _DashboardCustomerScreenState createState() => _DashboardCustomerScreenState();
}

class _DashboardCustomerScreenState extends State<DashboardCustomerScreen> {
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
      _showVerificationDialog(context, user.id);
    }
  }

  void _showVerificationDialog(BuildContext context, int userId) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    final _phoneController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Isi Profile terlebih dahulu'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Alamat'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your alamat';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Phone'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(LogoutEvent());
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final profile = Profile(
                    userId: userId,
                    username: _nameController.text,
                    alamat: _emailController.text,
                    nomer_telepon: _phoneController.text,
                  );

                  print('Profile: ${profile.toJson()}'); // Add logging here

                  context.read<ProfileBloc>().add(CreateProfile(profile));
                  context.read<ManagementUserBlock>().add(UserVerifiedAt(userId, DateTime.now().toIso8601String()));

                  Navigator.of(context).pop();
                } else {
                  print('Form validation failed'); // Add logging here
                }
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
        title: Text('Dashboard Customer'),
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
              SnackBar(content: Text('Profile')),
            );
          }
          if (state is BottomNavItemSelectedState && state.index == 2) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Order')),
            );
          }
          if (state is BottomNavItemSelectedState && state.index == 3) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Setting')),
            );
          }
        },
        builder: (context, state) {
          if (state is BottomNavItemSelectedState) {
            switch (state.index) {
              case 0:
                return VisitorItemScreen();
              case 1:
                final user = context.read<AuthBloc>().authProvider.user;
                return ShowProfileScreen(userId: user!.id);
              case 2:
                final user = context.read<AuthBloc>().authProvider.user;
                return ShowOrderProfileScreen(profileId: user!.id);
              case 3:
                return Center(child: Text('Profile Screen'));
              default:
                return VisitorItemScreen();
            }
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VisitorItemScreen(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          int currentIndex = 0;
          if (state is BottomNavItemSelectedState) {
            currentIndex = state.index;
          }
          return BottomNavigationBar(
            currentIndex: currentIndex,
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
                label: 'Setting',
              ),
            ],
          );
        },
      ),
    );
  }
}
