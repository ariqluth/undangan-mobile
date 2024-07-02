import 'package:flutter/material.dart';

class TamuDetailScreen extends StatelessWidget {
  final int undanganId;

  TamuDetailScreen({required this.undanganId});

  @override
  Widget build(BuildContext context) {
    // Fetch the details of the undangan using the undanganId
    // For simplicity, we'll just display the undanganId here
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Tamu'),
      ),
      body: Center(
        child: Text('Detail for Undangan ID: $undanganId'),
      ),
    );
  }
}
