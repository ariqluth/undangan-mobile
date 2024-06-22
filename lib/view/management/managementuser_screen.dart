import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/app/provider/management_user_block.dart';
import 'package:myapp/app/models/managementuser.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
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
                  title: Text(user.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${user.email}'),
                      Text('Email Verified At: ${user.emailVerifiedAt}'),
                      Text('Created At: ${user.createdAt}'),
                      Text('Updated At: ${user.updatedAt}'),
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
          title: Text('Edit Email Verified At'),
          content: TextField(
            controller: _emailVerifiedAtController,
            decoration: InputDecoration(labelText: 'Email Verified At'),
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
