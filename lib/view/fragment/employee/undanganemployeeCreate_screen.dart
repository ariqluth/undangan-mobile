import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/app/provider/order/order_bloc.dart';
import 'package:myapp/app/provider/order/order_event.dart';
import 'package:myapp/app/provider/order/order_state.dart';
import 'package:myapp/app/provider/undangan/undangan_bloc.dart';
import 'package:myapp/app/provider/undangan/undangan_event.dart';
import 'package:myapp/app/provider/undangan/undangan_state.dart';

class CreateUndanganForm extends StatefulWidget {
  final int orderListId;

  CreateUndanganForm({required this.orderListId});

  @override
  _CreateUndanganFormState createState() => _CreateUndanganFormState();
}

class _CreateUndanganFormState extends State<CreateUndanganForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaPengantinPriaController = TextEditingController();
  final _namaPengantinWanitaController = TextEditingController();
  final _tanggalPernikahanController = TextEditingController();
  final _lokasiPernikahanController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  LatLng _center = LatLng(-7.5944, 111.9047); // Nganjuk City coordinates
  LatLng? _pickedLocation;
  int? _selectedOrderId;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<OrderBloc>(context).add(ShowDropdown(widget.orderListId));
    _latitudeController.addListener(_updateLocation);
    _longitudeController.addListener(_updateLocation);
  }

  @override
  void dispose() {
    // Remove listeners when the widget is disposed
    _latitudeController.removeListener(_updateLocation);
    _longitudeController.removeListener(_updateLocation);

    _namaPengantinPriaController.dispose();
    _namaPengantinWanitaController.dispose();
    _tanggalPernikahanController.dispose();
    _lokasiPernikahanController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();

    super.dispose();
  }

  void _updateLocation() {
    final latitude = double.tryParse(_latitudeController.text);
    final longitude = double.tryParse(_longitudeController.text);

    if (latitude != null && longitude != null) {
      setState(() {
        _pickedLocation = LatLng(latitude, longitude);
        _center = _pickedLocation!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Undangan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  if (state is UndanganLoading) {
                    return CircularProgressIndicator();
                  } else if (state is OrderLoaded) {
                    return DropdownButtonFormField<int>(
                      value: _selectedOrderId,
                      decoration: InputDecoration(labelText: 'Order ID'),
                      items: state.Orders.map((order) {
                        return DropdownMenuItem<int>(
                          value: order.id,
                          child: Text(order.jumlah),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedOrderId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select an Order ID';
                        }
                        return null;
                      },
                    );
                  } else if (state is OrderError) {
                    return Text('Error: ${state.message}');
                  } else {
                    return Container();
                  }
                },
              ),
              TextFormField(
                controller: _namaPengantinPriaController,
                decoration: InputDecoration(labelText: 'Nama Pengantin Pria'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Nama Pengantin Pria';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _namaPengantinWanitaController,
                decoration: InputDecoration(labelText: 'Nama Pengantin Wanita'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Nama Pengantin Wanita';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tanggalPernikahanController,
                decoration: InputDecoration(labelText: 'Tanggal Pernikahan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Tanggal Pernikahan';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lokasiPernikahanController,
                decoration: InputDecoration(labelText: 'Lokasi Pernikahan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Lokasi Pernikahan';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _latitudeController,
                decoration: InputDecoration(labelText: 'Latitude'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Latitude';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _longitudeController,
                decoration: InputDecoration(labelText: 'Longitude'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Longitude';
                  }
                  return null;
                },
              ),
            
              SizedBox(height: 20),
              Container(
                height: 300,
                child: FlutterMap(
                  options: MapOptions(
                    center: _center,
                    zoom: 13.0,
                    onTap: (point, latlng) {
                      setState(() {
                        _pickedLocation = latlng;
                        _latitudeController.text = latlng.latitude.toString();
                        _longitudeController.text = latlng.longitude.toString();
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: _pickedLocation != null
                          ? [
                              Marker(
                                width: 80.0,
                                height: 80.0,
                                point: _pickedLocation!,
                                builder: (ctx) => Container(
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 40.0,
                                  ),
                                ),
                              ),
                            ]
                          : [],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    BlocProvider.of<UndanganBloc>(context).add(CreateUndangan(
                      order_id: _selectedOrderId!,
                      order_list_id: widget.orderListId,
                      nama_pengantin_pria: _namaPengantinPriaController.text,
                      nama_pengantin_wanita: _namaPengantinWanitaController.text,
                      tanggal_pernikahan: _tanggalPernikahanController.text,
                      lokasi_pernikahan: _lokasiPernikahanController.text,
                      latitude: _latitudeController.text,
                      longitude: _longitudeController.text,
                    ));
                    Navigator.pop(context); // Navigate back to the previous screen
                  }
                },
                child: Text('Create Undangan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}