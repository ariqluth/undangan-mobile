import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/app/models/tamu.dart';
import 'package:myapp/app/provider/tamu/tamu_bloc.dart';
import 'package:myapp/app/provider/tamu/tamu_event.dart';
import 'package:myapp/app/provider/tamu/tamu_state.dart';
import 'package:myapp/app/service/api_service.dart';
import 'package:myapp/app/service/auth.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:url_launcher/url_launcher.dart';

class TamuShowDetailScreen extends StatefulWidget {
  final int id;

  TamuShowDetailScreen({required this.id});

  @override
  _TamuDetailScreenState createState() => _TamuDetailScreenState();
}

class _TamuDetailScreenState extends State<TamuShowDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tamu Detail ${widget.id}'),
      ),
      body: BlocProvider(
        create: (context) => TamuBloc(
          RepositoryProvider.of<ApiService>(context),
          RepositoryProvider.of<AuthProvider>(context),
        )..add(ShowTamu(widget.id)),
        child: Column(
          children: [
            Expanded(
              child: TamuDetailView(id: widget.id),
            ),
          ],
        ),
      ),
    );
  }
}

class TamuDetailView extends StatelessWidget {
  final int id;

  TamuDetailView({required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TamuBloc, TamuState>(
      builder: (context, state) {
        if (state is TamuLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is TamuLoaded) {
          return TamuShowTable(tamus: state.tamus);
        } else if (state is TamuError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return Center(child: Text('Unknown state'));
        }
      },
    );
  }
}

class TamuShowTable extends StatelessWidget {
  final List<Tamu> tamus;

  TamuShowTable({required this.tamus});

  void _sendWhatsAppMessage(String phoneNumber, String message) async {
    final url = 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tamus.length,
      itemBuilder: (context, index) {
        final tamu = tamus[index];
        final message = 'http://127.0.0.1:8000/undangan/${tamu.undangan_id}/?nama_tamu=${tamu.nama_tamu}';

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
                      Text('Nama Tamu: ${tamu.nama_tamu}'),
                      Text('Email Tamu: ${tamu.email_tamu}'),
                      Text('Alamat Tamu: ${tamu.alamat_tamu}'),
                      Text('Nomer Tamu: ${tamu.nomer_tamu}'),
                      Text('Status: ${tamu.status}'),
                      Text('Kategori: ${tamu.kategori}'),
                      Text('Tipe-Undangan: ${tamu.tipe_undangan}'),
                      SizedBox(height: 16.0),
                      Center(
                        child: PrettyQr(
                          data: tamu.kodeqr!,
                          size: 200.0,
                          roundEdges: true,
                          errorCorrectLevel: QrErrorCorrectLevel.M,
                          typeNumber: null,
                          image: NetworkImage('https://blog.ippon.fr/content/images/2023/09/RGFzaGF0YXJfRGV2ZWxvcGVyX092ZXJJdF9jb2xvcl9QR19zaGFkb3c-.png'), // Ganti dengan path logo Anda
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => _sendWhatsAppMessage(tamu.nomer_tamu!, message),
                          child: Text('Send WhatsApp Message'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
