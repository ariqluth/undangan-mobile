import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/app/provider/management_user_block.dart';
import 'package:myapp/app/models/managementuser.dart';
import 'package:myapp/app/service/api_service.dart';
class ManagementUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiService = context.read<ApiService>();
    print('ApiService: $apiService'); // Debug print to verify ApiService

    return Scaffold(
      appBar: AppBar(
        title: Text('Management User'),
      ),
      body: BlocBuilder<ManagementUserBlock, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return ListTile(
                  title: Text('Nama: ${user.name}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${user.email}'),
                      Text('Verify: ${user.emailVerifiedAt}'),
                      Text('Dibuat: ${user.createdAt}'),
                      Text('Diupdate: ${user.updatedAt}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _showEditDialog(context, user);
                    },
                  ),
                );
              },
            );
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('No users found'));
          }
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, Managementuser user) {
    final _emailVerifiedAtController = TextEditingController(text: user.emailVerifiedAt);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Verify'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _emailVerifiedAtController,
                decoration: InputDecoration(labelText: 'Verify'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Set the verification date to the current date
                  _emailVerifiedAtController.text = DateTime.now().toIso8601String();
                },
                child: Text('Verify Now'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Clear the verification date
                  _emailVerifiedAtController.clear();
                },
                child: Text('Clear Verification'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<ManagementUserBlock>().add(UpdateUserVerifiedAt(user.id, _emailVerifiedAtController.text));
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}