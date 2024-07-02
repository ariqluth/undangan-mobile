import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/app/models/profile.dart';
import 'package:myapp/app/provider/profile/profile_bloc.dart';
import 'package:myapp/app/provider/profile/profile_event.dart';
import 'package:myapp/app/provider/profile/profile_state.dart';

class ShowProfileScreen extends StatelessWidget {
  final int userId;

  ShowProfileScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    // Dispatch the ShowProfile event when the screen is initialized
    context.read<ProfileBloc>().add(ShowProfile(userId));

    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final profile = state.Profiles.firstWhere((profile) => profile.userId == userId);
            return _buildProfileDetails(context, profile);
          } else if (state is ProfileError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return Center(child: Text('No profile data'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final profile = (context.read<ProfileBloc>().state as ProfileLoaded)
              .Profiles
              .firstWhere((profile) => profile.userId == userId);
          _showUpdateProfileDialog(context, profile);
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget _buildProfileDetails(BuildContext context, Profile profile) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileField('Username', profile.username),
          SizedBox(height: 8),
          _buildProfileField('Alamat', profile.alamat),
          SizedBox(height: 8),
          _buildProfileField('Phone', profile.nomer_telepon),
        ],
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 18)),
        Divider(),
      ],
    );
  }

  void _showUpdateProfileDialog(BuildContext context, Profile profile) {
    final _formKey = GlobalKey<FormState>();
    final _usernameController = TextEditingController(text: profile.username);
    final _alamatController = TextEditingController(text: profile.alamat);
    final _phoneController = TextEditingController(text: profile.nomer_telepon);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Profile'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _alamatController,
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
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final updatedProfile = Profile(
                    userId: profile.userId,
                    username: _usernameController.text,
                    alamat: _alamatController.text,
                    nomer_telepon: _phoneController.text,
                  );

                  context.read<ProfileBloc>().add(UpdateProfile(profile.userId, updatedProfile));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
