import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/view/fragment/admin/orderadmin_screen.dart';
import 'package:myapp/view/masterdata/item_screen.dart';
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
        title: Text('Selamat Datang'),
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
                return ManagementUserScreen();
              case 2:
                return ItemScreen();
              case 3:
                return ShowOrderAdminProfileScreen();
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
                label: 'Management User',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Undangan Item',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Management Order',
              ),
            ],
          );
        },
      ),
    );
  }
}