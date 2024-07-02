import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/app/provider/order/order_bloc.dart';
import 'package:myapp/app/provider/order/order_event.dart';
import 'package:myapp/app/provider/order/order_state.dart';


class ShowOrderAdminProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dispatch the GetOrders event when the screen is initialized
    context.read<OrderBloc>().add(GetOrders());

    return Scaffold(
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            debugPrint('OrderLoading state');
            return Center(child: CircularProgressIndicator());
          } else if (state is OrderLoaded) {
            debugPrint('OrderLoaded state with ${state.Orders.length} orders');
            return ListView.builder(
              itemCount: state.Orders.length,
              itemBuilder: (context, index) {
                final order = state.Orders[index];
                debugPrint('Displaying order: ${order.id}');
                return ListTile(
                  title: Text('Order ${order.id}'),
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          debugPrint('Verify button pressed for order: ${order.id}');
                          context.read<OrderBloc>().add(BroadcastOrder(order.id!));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          debugPrint('Cancel button pressed for order: ${order.id}');
                          context.read<OrderBloc>().add(CloseOrder(order.id!));
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is OrderError) {
            debugPrint('OrderError state: ${state.message}');
            return Center(child: Text('Error: ${state.message}'));
          } else {
            debugPrint('No orders found state');
            return Center(child: Text('No orders found'));
          }
        },
      ),
    );
  }
}
