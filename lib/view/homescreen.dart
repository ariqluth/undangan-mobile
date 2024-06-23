import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app/provider/auth_bloc.dart';
import '../view/management/managementuser_screen.dart';
import '../app/provider/bottom_nav_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
        },
        builder: (context, state) {
          if (state is BottomNavItemSelectedState) {
            switch (state.index) {
              case 0:
                return Center(child: Text('Home Screen'));
              case 1:
                try {
                  return ManagementUserScreen();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error loading Management User Screen: $e')),
                  );
                  return Center(child: Text('Error loading Management User Screen'));
                }
              case 2:
                return Center(child: Text('Profile Screen'));
              default:
                return Center(child: Text('Home Screen'));
            }
          }
          return Center( child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Home Screen'),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ManagementUserScreen()),
                          );
                        },
                        child: Text('Go to Management User'),
                      ),
                    ],
                  ),);
        },
      ),
      bottomNavigationBar: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: state is BottomNavItemSelectedState ? state.index : 0,
            onTap: (index) {
              context.read<BottomNavBloc>().add(BottomNavItemSelected(index));
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Management User',
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
