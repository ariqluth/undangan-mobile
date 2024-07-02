import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/app/provider/auth_bloc.dart';
import 'package:myapp/app/provider/orderlist/orderlist_bloc.dart'; // Ensure this import is correct
import 'package:myapp/app/provider/orderlist/orderlist_event.dart';
import 'package:myapp/app/provider/verifyorder/verifyorder_bloc.dart';
import 'package:myapp/app/provider/verifyorder/verifyorder_event.dart';
import 'package:myapp/app/provider/verifyorder/verifyorder_state.dart';
import 'dart:math';

String generateRandomString(int length) {
  const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => characters.codeUnitAt(random.nextInt(characters.length)),
  ));
}

class ShowVerifyProfilePetugasScreen extends StatelessWidget {
  final int userId;

  ShowVerifyProfilePetugasScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    // Dispatch the GetOrderVerifyByPetugas event when the screen is initialized
    context.read<OrderVerifyBloc>().add(GetOrderVerifyByPetugas(userId));

    return Scaffold(
      body: BlocBuilder<OrderVerifyBloc, OrderVerifyState>(
        builder: (context, state) {
          if (state is OrderVerifyLoading) {
            debugPrint('OrderLoading state');
            return Center(child: CircularProgressIndicator());
          } else if (state is OrderVerifyLoaded) {
            debugPrint('OrderLoaded state with ${state.OrdersVerify.length} Order');
            return ListView.builder(
              itemCount: state.OrdersVerify.length,
              itemBuilder: (context, index) {
                final order = state.OrdersVerify[index];
                debugPrint('Displaying order: ${order.id_petugas}');
                return ListTile(
                  title: Text('OrderVerify ${order.id_petugas}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama Item: ${order.nama_item ?? 'N/A'}'),
                      Text('Jumlah: ${order.jumlah}'),
                      Text('Status: ${order.status}'),
                      Text('Tanggal Terakhir: ${order.tanggal_terakhir}'),
                      Text('Nama Customer: ${order.nama_pelanggan}'),
                      Text('Kode: ${order.kode}'),
                      Text('Nama Petugas: ${order.nama_petugas}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      final user = context.read<AuthBloc>().authProvider.user;                 
                      _showConfirmationDialog(context, order.orderId ?? 0, order.id ?? 0, user?.id ?? 0,);
                    },
                  ),
                );
              },
            );
          } else if (state is OrderVerifyError) {
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

  void _showConfirmationDialog(BuildContext context, int orderId, int verifyId, int profileId) {
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
                String randomCode = generateRandomString(4);
                Navigator.of(context).pop(); // Close the dialog
                context.read<OrderlistBloc>().add(CreateOrderList(orderId, verifyId, profileId, randomCode, 'proses'));
              },
            ),
          ],
        );
      },
    );
  }
}
