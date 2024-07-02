import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/app/provider/order/order_bloc.dart';
import 'package:myapp/app/provider/order/order_event.dart';
import 'package:myapp/app/provider/order/order_state.dart';

class ShowOrderProfileScreen extends StatelessWidget {
  final int profileId;

  ShowOrderProfileScreen({required this.profileId});

  @override
  Widget build(BuildContext context) {
    // Dispatch the ShowOrderProfile event when the screen is initialized
    context.read<OrderBloc>().add(showOrderProfile(profileId));

    return Scaffold(
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is OrderLoaded) {
            return ListView.builder(
              itemCount: state.Orders.length,
              itemBuilder: (context, index) {
                final order = state.Orders[index];
                return ListTile(
                  title: Text('Order ID: ${order.item_id}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama Item: ${order.nama_item ?? 'N/A'}'),
                      Text('Jumlah: ${order.jumlah}'),
                      Text('Status: ${order.status}'),
                      Text('Tanggal Terakhir: ${order.tanggal_terakhir}'),
                      Text('Kode: ${order.kode}'),
                    ],
                  ),
                );
              },
            );
          } else if (state is OrderError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return Center(child: Text('No orders found'));
          }
        },
      ),
    );
  }
}
