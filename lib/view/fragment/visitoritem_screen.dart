// visitoritem_screen 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/app/provider/auth_bloc.dart';
import 'package:myapp/app/provider/item/item_bloc.dart';
import 'package:myapp/app/provider/item/item_state.dart';

class VisitorItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state is ItemLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ItemLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                final user = context.read<AuthBloc>().authProvider.user;
                final userId = user?.id;
                return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/itemdetailscreen',
                        arguments: {
                          'item': item,
                          'userId': userId,
                        },
                      );
                    },
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Image.network(
                              item.gambar,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item.namaItem,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ));
              },
            );
          } else if (state is ItemError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('No items found'));
          }
        },
      ),
    );
  }
}
