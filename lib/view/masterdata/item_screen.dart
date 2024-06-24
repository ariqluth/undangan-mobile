// item_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../app/models/item.dart';
import '../../app/provider/item/item_bloc.dart';
import '../../app/provider/item/item_event.dart';
import '../../app/provider/item/item_state.dart';
import '../../app/service/api_service.dart';
import '../../app/service/auth.dart';

class ItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Undangan List Item'),
      ),
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state is ItemLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ItemLoaded) {
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return ListTile(
                  title: Text('Nama tema undangan: ${item.namaItem}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gambar: ${item.gambar}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditDialog(context, item);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteDialog(context, item.id!);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is ItemError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('No items found'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final _namaItemController = TextEditingController();
    File? _imageFile;

    Future<void> _pickImage() async {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Undangan Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _namaItemController,
                decoration: InputDecoration(labelText: 'Nama Item'),
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pilih Gambar'),
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
                if (_imageFile != null) {
                  final item = Item(
                    userId: 1, // Automatically set user_id to 1
                    gambar: _imageFile!.path,
                    namaItem: _namaItemController.text,
                  );
                  context.read<ItemBloc>().add(CreateItem(item, _imageFile!));
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select an image')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Item item) {
    final _namaItemController = TextEditingController(text: item.namaItem);
    final _gambarController = TextEditingController(text: item.gambar);
    File? _imageFile;

    Future<void> _pickImage() async {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Undangan Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _namaItemController,
                decoration: InputDecoration(labelText: 'Nama Item'),
              ),
              TextField(
                controller: _gambarController,
                decoration: InputDecoration(labelText: 'Gambar'),
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pilih Gambar'),
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
                final updatedItem = Item(
                  id: item.id,
                  userId: 1, // Automatically set user_id to 1
                  gambar: _imageFile != null ? _imageFile!.path : item.gambar,
                  namaItem: _namaItemController.text,
                );
                context.read<ItemBloc>().add(UpdateItem(item.id!, updatedItem, _imageFile));
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, int itemId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Item'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<ItemBloc>().add(DeleteItem(itemId));
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}