import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/app/models/item.dart';
import 'package:myapp/app/models/order.dart';
import 'package:myapp/app/provider/order/order_bloc.dart';
import 'package:myapp/app/provider/order/order_event.dart';
import 'package:myapp/app/provider/order/order_state.dart';
import 'package:myapp/app/service/auth.dart';

class VisitorItemDetailScreen extends StatelessWidget {
  final int userId;
  final Item item;
  final _formKey = GlobalKey<FormState>();
  final _jumlahController = TextEditingController();

  VisitorItemDetailScreen({required this.item, required this.userId});

  String _generateRandomCode(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
  }

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
                    controller: _jumlahController,
                    decoration: InputDecoration(labelText: 'Jumlah'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Jumlah';
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
                        Fluttertoast.showToast(
                          msg: "Berhasil melakukan order",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
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
                                profile_id: userId,
                                item_id: item.id!,
                                kode: _generateRandomCode(8), // Generate random alphanumeric code
                                tanggal_terakhir: DateTime.now().toString(), // Set current date
                                jumlah: _jumlahController.text,
                                status: 'pending', // Set default status
                              );
                              print('Order Data: ${order.toJson()}'); // Print order data
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
