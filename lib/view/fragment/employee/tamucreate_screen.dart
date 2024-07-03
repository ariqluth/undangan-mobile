import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/app/provider/tamu/tamu_bloc.dart';
import 'package:myapp/app/provider/tamu/tamu_event.dart';

class CreateTamuForm extends StatefulWidget {
  final int undanganId;

  CreateTamuForm({required this.undanganId});

  @override
  _CreateTamuFormState createState() => _CreateTamuFormState();
}

class _CreateTamuFormState extends State<CreateTamuForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaTamuController = TextEditingController();
  final _emailTamuController = TextEditingController();
  final _alamatTamuController = TextEditingController();
  final _nomerTamuController = TextEditingController();
  final _kategoriController = TextEditingController();
  final _tipeUndanganController = TextEditingController();

  String _selectedKategori = 'family';
  String _selectedTipeUndangan = 'fisik';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _namaTamuController.dispose();
    _emailTamuController.dispose();
    _alamatTamuController.dispose();
    _nomerTamuController.dispose();
    _kategoriController.dispose();
    _tipeUndanganController.dispose();
    super.dispose();
  }

  String _generateKodeQR(String namaTamu, String nomerTamu) {
    return '$namaTamu-$nomerTamu';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Tamu'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaTamuController,
                decoration: InputDecoration(labelText: 'Nama Tamu'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Nama Tamu';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailTamuController,
                decoration: InputDecoration(labelText: 'Email Tamu'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Email Tamu';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _alamatTamuController,
                decoration: InputDecoration(labelText: 'Alamat Tamu'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Alamat Tamu';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nomerTamuController,
                decoration: InputDecoration(labelText: 'Nomer Tamu'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Nomer Tamu';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedKategori,
                decoration: InputDecoration(labelText: 'Kategori'),
                items: ['family', 'teman'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedKategori = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a Kategori';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedTipeUndangan,
                decoration: InputDecoration(labelText: 'Tipe Undangan'),
                items: ['fisik', 'digital'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedTipeUndangan = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a Tipe Undangan';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final kodeqr = _generateKodeQR(_namaTamuController.text, _nomerTamuController.text);
                    BlocProvider.of<TamuBloc>(context).add(CreateTamu(
                      undangan_id: widget.undanganId,
                      nama_tamu: _namaTamuController.text,
                      email_tamu: _emailTamuController.text,
                      nomer_tamu: _nomerTamuController.text,
                      alamat_tamu: _alamatTamuController.text,
                      status: 'belum datang',
                      kategori: _selectedKategori,
                      kodeqr: kodeqr,
                      tipe_undangan: _selectedTipeUndangan,
                    ));
                    Navigator.pop(context); // Navigate back to the previous screen
                  }
                },
                child: Text('Create Tamu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
