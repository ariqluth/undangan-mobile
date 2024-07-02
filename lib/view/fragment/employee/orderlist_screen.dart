import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/app/provider/orderlist/orderlist_bloc.dart'; // Ensure this import is correct
import 'package:myapp/app/provider/orderlist/orderlist_event.dart';
import 'package:myapp/app/provider/orderlist/orderlist_state.dart';
import 'package:myapp/view/fragment/employee/undanganemployeeView_screen.dart';

class ShowOrderlistScreen extends StatelessWidget {
  final int userId;

  ShowOrderlistScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    // Dispatch the ShowPetugasOrderList event when the screen is initialized
    context.read<OrderlistBloc>().add(showPetugasOrderList(userId));

    return Scaffold(
      body: BlocBuilder<OrderlistBloc, OrderListState>(
        builder: (context, state) {
          if (state is OrderListLoading) {
            debugPrint('OrderLoading state');
            return Center(child: CircularProgressIndicator());
          } else if (state is OrderListLoaded) {
            debugPrint('OrderLoaded state with ${state.OrderLists.length} Order');
            return ListView.builder(
              itemCount: state.OrderLists.length,
              itemBuilder: (context, index) {
                final order = state.OrderLists[index];
                debugPrint('Displaying order: ${order.id}');
                return ListTile(
                  title: Text('Id Order list: ${order.id}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('id: ${order.nomerid ?? 0}'),
                      Text('Nama Item: ${order.nama_item ?? 'N/A'}'),
                      Text('Jumlah: ${order.jumlah}'),
                      Text('Status: ${order.status}'),
                      Text('Tanggal Terakhir: ${order.tanggal_terakhir}'),
                      Text('Nama Customer: ${order.name}'),
                      Text('Kode: ${order.kode_undangan}'),
                      Text('Nama Petugas: ${order.name}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showUpdateOrderList(context, order.id ?? 0, order.id ?? 0, order.profile_id ?? 0);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: () {
                          _showUndangan(context, order.id ?? 0);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is OrderListError) {
            debugPrint('OrderError state: ${state.message}');
            return Center(child: Text('Error: ${state.message}'));
          } else {
            debugPrint('No Order found state');
            return Center(child: Text('No Order found'));
          }
        },
      ),
    );
  }

  void _showUpdateOrderList(BuildContext context, int orderId, int verifyId, int profileId) {
    debugPrint('Showing confirmation dialog for orderlist: $verifyId');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Verification'),
          content: Text('Are you sure you want to order list?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                debugPrint('Verification cancelled for order: $verifyId');
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                debugPrint('Verification confirmed for order: $verifyId');
                Navigator.of(context).pop(); // Close the dialog
                context.read<OrderlistBloc>().add(CreateOrderList(orderId, verifyId, profileId, 'und1', 'proses'));
              },
            ),
          ],
        );
      },
    );
  }

   void _showUndangan(BuildContext context, int orderListId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UndanganScreen(orderListId: orderListId),
      ),
    );
  }

}
