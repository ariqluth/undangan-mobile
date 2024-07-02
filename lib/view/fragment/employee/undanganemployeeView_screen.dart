import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/app/provider/undangan/undangan_bloc.dart';
import 'package:myapp/app/provider/undangan/undangan_event.dart';
import 'package:myapp/app/provider/undangan/undangan_state.dart';
import 'package:myapp/app/service/api_service.dart';
import 'package:myapp/app/service/auth.dart';
import 'package:myapp/view/fragment/employee/tamu_screen.dart';
import 'package:myapp/view/fragment/employee/undanganemployeeCreate_screen.dart';

class UndanganScreen extends StatelessWidget {
  final int orderListId; 

  UndanganScreen({required this.orderListId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Undangan List'),
      ),
      body: BlocProvider(
        create: (context) => UndanganBloc(
          RepositoryProvider.of<ApiService>(context),
          RepositoryProvider.of<AuthProvider>(context),
        )..add(ShowUndanganbypetugas(orderListId)),
        child: UndanganView(orderListId: orderListId),
      ),
    );
  }
}

class UndanganView extends StatelessWidget {
  final int orderListId;

  UndanganView({required this.orderListId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UndanganBloc, UndanganState>(
      builder: (context, state) {
        if (state is UndanganLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is UndanganLoaded) {
          return UndanganTable(undangans: state.undangans);
        } else if (state is UndanganEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateUndanganForm(orderListId: orderListId),
                      ),
                    );
                  },
                  child: Text('Tambah Undangan Baru'),
                ),
              ],
            ),
          );
        } else if (state is UndanganError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return Center(child: Text('Unknown state'));
        }
      },
    );
  }
}

class UndanganTable extends StatelessWidget {
  final List<dynamic> undangans;

  UndanganTable({required this.undangans});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: undangans.length,
      itemBuilder: (context, index) {
        final undangan = undangans[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.0),
                      Text('Nama Pengantin Pria: ${undangan['nama_pengantin_pria']}'),
                      Text('Nama Pengantin Wanita: ${undangan['nama_pengantin_wanita']}'),
                      Text('Tanggal Pernikahan: ${undangan['tanggal_pernikahan']}'),
                      Text('Lokasi Pernikahan: ${undangan['lokasi_pernikahan']}'),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TamuDetailScreen(undanganId: undangan['id']),
                        ),
                      );
                    },
                    child: Text('Detail'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, 
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}





