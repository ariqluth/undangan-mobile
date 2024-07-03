import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/app/models/tamu.dart';
import 'package:myapp/app/provider/tamu/tamu_bloc.dart';
import 'package:myapp/app/provider/tamu/tamu_event.dart';
import 'package:myapp/app/provider/tamu/tamu_state.dart';
import 'package:myapp/app/service/api_service.dart';
import 'package:myapp/app/service/auth.dart';
import 'package:myapp/view/fragment/employee/scanner/scanner_undangan.dart';
import 'package:myapp/view/fragment/employee/tamuDetail_screen.dart';
import 'package:myapp/view/fragment/employee/tamucreate_screen.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class TamuDetailScreen extends StatefulWidget {
  final int undanganId;

  TamuDetailScreen({required this.undanganId});

  @override
  _TamuDetailScreenState createState() => _TamuDetailScreenState();
}

class _TamuDetailScreenState extends State<TamuDetailScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Tamu> _filteredTamus = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<TamuBloc>().add(SearchTamuEvent(_searchController.text));
  }

 void _exportToExcel(List<Tamu> tamus) async {
  try {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // Add headers
    sheetObject.appendRow([
      'Undangan Id',
      'Nama Tamu',
      'Email Tamu',
      'Alamat Tamu',
      'Nomer Tamu',
      'Status',
      'Kategori',
      'KodeQr',
      'Tipe-Undangan'
    ]);

    // Add data
    for (var tamu in tamus) {
      sheetObject.appendRow([
        tamu.undangan_id ?? '',
        tamu.nama_tamu ?? '',
        tamu.email_tamu ?? '',
        tamu.alamat_tamu ?? '',
        tamu.nomer_tamu ?? '',
        tamu.status ?? '',
        tamu.kategori ?? '',
        tamu.kodeqr ?? '',
        tamu.tipe_undangan ?? ''
      ]);
    }

    // Save the file
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    }

    if (directory != null) {
      final path = '${directory.path}/tamu205.xlsx';
      final file = File(path);
      await file.writeAsBytes(excel.encode()!);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exported to $path')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to get directory')));
    }
  } catch (e) {
    print('Error exporting to Excel: $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to export to Excel')));
  }
}

void _importFromExcel() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xlsx'],
  );

  if (result != null) {
    File file = File(result.files.single.path!);
    var bytes = file.readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    List<Tamu> importedTamus = [];

    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table];
      if (sheet != null) {
        for (var row in sheet.rows.skip(1)) { 
          if (row.isNotEmpty) {
            print('Processing row: $row');
            var tamu = Tamu(
              undangan_id: row[0]?.value?.toInt() ?? 0,
              nama_tamu: row[1]?.value?.toString() ?? '',
              email_tamu: row[2]?.value?.toString() ?? '',
              alamat_tamu: row[3]?.value?.toString() ?? '',
              nomer_tamu: row[4]?.value?.toString() ?? '',
              status: row[5]?.value?.toString() ?? '',
              kategori: row[6]?.value?.toString() ?? '',
              kodeqr: row[7]?.value?.toString() ?? '',
              tipe_undangan: row[8]?.value?.toString() ?? '',
            );
            importedTamus.add(tamu);
          }
        }
      }
    }

    context.read<TamuBloc>().add(ImportTamuEvent(importedTamus, widget.undanganId));

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Imported from Excel')));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tamu List'),
      ),
      body: BlocProvider(
        create: (context) => TamuBloc(
          RepositoryProvider.of<ApiService>(context),
          RepositoryProvider.of<AuthProvider>(context),
        )..add(ShowTamubypetugas(widget.undanganId)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _exportToExcel(_filteredTamus);
                  },
                  child: Text('Export to Excel'),
                ),
                ElevatedButton(
                  onPressed: _importFromExcel,
                  child: Text('Import from Excel'),
                ),
              ],
            ),
            Expanded(
              child: TamuView(undanganId: widget.undanganId),
            ),
          ],
        ),
      ),
    );
  }
}

class TamuView extends StatelessWidget {
  final int undanganId;

  TamuView({required this.undanganId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TamuBloc, TamuState>(
      builder: (context, state) {
        if (state is TamuLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is TamuLoaded) {
          return TamuTable(tamus: state.tamus, undanganId: undanganId);
        } else if (state is TamuEmpty) {
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
                        builder: (context) => CreateTamuForm(undanganId: undanganId),
                      ),
                    );
                  },
                  child: Text('Tambah Tamu Baru'),
                ),
              ],
            ),
          );
        } else if (state is TamuError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return Center(child: Text('Unknown state'));
        }
      },
    );
  }
}

class TamuTable extends StatelessWidget {
  final List<Tamu> tamus;
   final int undanganId;

  TamuTable({required this.tamus, required this.undanganId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRViewExample(),
                  ),
                );
              },
              child: Text('Scan QR Code'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateTamuForm(undanganId: undanganId), // Ganti dengan undanganId yang sesuai
                  ),
                );
              },
              child: Text('Create Tamu'),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: tamus.length,
            itemBuilder: (context, index) {
              final tamu = tamus[index];
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
                                builder: (context) => TamuShowDetailScreen(id: tamu.id!),
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
          ),
        ),
      ],
    );
  }
}
