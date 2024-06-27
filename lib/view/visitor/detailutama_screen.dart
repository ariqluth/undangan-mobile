import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/app/models/item.dart';
import 'package:myapp/app/models/order.dart';
import 'package:myapp/app/provider/order/order_bloc.dart';
import 'package:myapp/app/provider/order/order_event.dart';
import 'package:myapp/app/provider/order/order_state.dart';
import 'package:myapp/app/service/auth.dart';

class ItemDetailScreen extends StatelessWidget {
  final Item item;
  final _formKey = GlobalKey<FormState>();
  final _profileIdController = TextEditingController();
  final _itemIdController = TextEditingController();
  final _kodeController = TextEditingController();
  final _tanggalTerakhirController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _statusController = TextEditingController();

  ItemDetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.namaItem),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(item.gambar),
            SizedBox(height: 16.0),
            Text(
              item.namaItem,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _profileIdController,
                    decoration: InputDecoration(labelText: 'Profile ID'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Profile ID';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _itemIdController,
                    decoration: InputDecoration(labelText: 'Item ID'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Item ID';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _kodeController,
                    decoration: InputDecoration(labelText: 'Kode'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Kode';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _tanggalTerakhirController,
                    decoration: InputDecoration(labelText: 'Tanggal Terakhir'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Tanggal Terakhir';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _jumlahController,
                    decoration: InputDecoration(labelText: 'Jumlah'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Jumlah';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _statusController,
                    decoration: InputDecoration(labelText: 'Status'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Status';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  BlocConsumer<OrderBloc, OrderState>(
                    listener: (context, state) {
                      if (state is OrderError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      } else if (state is OrderLoaded) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Order submitted successfully')),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is OrderLoading) {
                        return CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final authProvider = context.read<AuthProvider>();
                            if (authProvider.user == null) {
                              Navigator.of(context).pushNamed('/loginscreen');
                            } else {
                              final order = Order(
                                profileId: int.parse(_profileIdController.text),
                                itemId: int.parse(_itemIdController.text),
                                kode: _kodeController.text,
                                tanggalTerakhir: _tanggalTerakhirController.text,
                                jumlah: _jumlahController.text,
                                status: _statusController.text,
                              );
                              context.read<OrderBloc>().add(CreateOrder(order));
                            }
                          }
                        },
                        child: Text('Submit Order'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
