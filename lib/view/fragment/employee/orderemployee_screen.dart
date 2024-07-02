import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/app/provider/auth_bloc.dart';
import 'package:myapp/app/provider/order/order_bloc.dart';
import 'package:myapp/app/provider/order/order_event.dart';
import 'package:myapp/app/provider/order/order_state.dart';
import 'package:myapp/app/provider/verifyorder/verifyorder_bloc.dart';
import 'package:myapp/app/provider/verifyorder/verifyorder_event.dart';

class ShowVerifyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dispatch the VerifyStatusOrder event when the screen is initialized
    context.read<OrderBloc>().add(verifyStatusOrder());

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
                      Text('Nama Customer: ${order.name}'),
                      Text('Kode: ${order.kode}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                     final user = context.read<AuthBloc>().authProvider.user;
                      if (user != null) {
                        _showConfirmationDialog(context, order.id!, user.id);
                      } else {
                        debugPrint('User is not logged in');
                        // Handle the case where the user is not logged in
                      }
                    },
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

   void _showConfirmationDialog(BuildContext context, int orderId, int profileId) {
    debugPrint('Showing confirmation dialog for order: $profileId');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Verification'),
          content: Text('Are you sure you want to verify this order?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                debugPrint('Verification cancelled for order: $profileId');
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                debugPrint('Verification confirmed for order: $profileId');
                Navigator.of(context).pop(); // Close the dialog
                context.read<OrderVerifyBloc>().add(CreateOrderVerify(orderId, profileId));
              },
            ),
          ],
        );
      },
    );
  }
}
