// rest_api.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:myapp/app/models/orderlist.dart';
import 'package:myapp/app/models/orderverify.dart';
import 'package:myapp/app/models/profile.dart';
import 'package:myapp/app/models/undangan.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

import 'package:myapp/app/models/managementuser.dart';
import '../models/item.dart';
import '../models/tamu.dart';
import '../models/order.dart';

class ApiService {
  // final String baseUrl = "https://weddingcheck.polinema.web.id/api";
  final String baseUrl = "https://6751-2001-448a-5040-4bfb-6812-d32-3b10-4316.ngrok-free.app/api";

// management-user
  Future<List<Managementuser>> getUsers(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/management-user'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Managementuser.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }


  Future<void> updateUserVerifiedAt(int id, String emailVerifiedAt, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/management-user/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'email_verified_at': emailVerifiedAt,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }

// order
 Future<List<Order>> getOrders(String token) async {
    final response = await http.get(Uri.parse('$baseUrl/order'),
   headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }
  );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((order) => Order.fromJson(order)).toList();
    } else {
      throw Exception('Failed to load order');
    }
  }

  Future<Order> createOrder(Order order, String token) async {
    final url = Uri.parse('$baseUrl/order');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode(order.toJson());

    print('Request URL: $url');
    print('Request Headers: $headers');
    print('Request Body: $body');

    final response = await http.post(url, headers: headers, body: body);

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 201) {
      return Order.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create order: ${response.body}');
    }
  }

  Future<Order> showOrder(int id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/order/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return Order.fromJson(jsonResponse);
    } else {
      print('Failed to load order: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load order');
    }
  }

   Future<List<Order>> showOrderProfile(int profileId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/order/profile/$profileId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return Order.fromJsonList(jsonResponse);
    } else {
      print('Failed to load orders: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load orders');
    }
  }

  Future<Order> updateOrder(int id, Order order, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/order/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(order.toJson()),
    );

    if (response.statusCode == 200) {
      return Order.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update order');
    }
  }

  Future<void> deleteOrder(int id, String token) async {
    final response = await http.delete(Uri.parse('$baseUrl/order/$id'),
    headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete order');
    }
  }
  
  Future<void> broadcastOrder(int id, String token) async {
  final response = await http.get(
    Uri.parse('$baseUrl/order/broadcast/$id'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to broadcast order');
  }
}

Future<void> closeOrder(int id, String token) async {
  final response = await http.get(
    Uri.parse('$baseUrl/order/close/$id'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to broadcast order');
  }
}

Future<List<Order>> verifyStatusOrder(String token) async {
  final url = '$baseUrl/order/status/verify';
  print('Requesting: $url');
  print('Using token: $token');

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print('Response body: ${response.body}');
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((order) => Order.fromJson(order)).toList();
  } else {
    print('Failed with status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to load order verify status');
  }
}


 Future<List<Item>> getItemsVisitor() async {
    final response = await http.get(
      Uri.parse('$baseUrl/visitor'),
    ); 
     if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Item.fromJson(item)).toList();
    } else {
      print('Failed to load items: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load items');
    }
  }


 Future<List<Item>> getItems(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/item'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Item.fromJson(item)).toList();
    } else {
      print('Failed to load items: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load items');
    }
  }

 Future<Item> createItem(Item item, String token, File imageFile) async {
    var uri = Uri.parse('$baseUrl/item');
    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Content-Type'] = 'multipart/form-data';

    // Attach the image file
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var multipartFile = http.MultipartFile('gambar', stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);
    // Add other fields
    request.fields['user_id'] = item.userId.toString();
    request.fields['nama_item'] = item.namaItem;

    var response = await request.send();

    if (response.statusCode == 201) {
      var responseData = await response.stream.bytesToString();
      return Item.fromJson(json.decode(responseData));
    } else {
      var responseData = await response.stream.bytesToString();
      print('Failed to create item: ${response.statusCode} $responseData');
      throw Exception('Failed to create item');
    }
  }

  Future<Item> showItem(int id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/item/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return Item.fromJson(jsonResponse);
    } else {
      print('Failed to load item: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load item');
    }
  }

   Future<Item> updateItem(int id, Item item, String token, File? imageFile) async {
    var uri = Uri.parse('$baseUrl/item/$id');
    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Content-Type'] = 'multipart/form-data';

    request.fields['_method'] = 'PUT';

    if (imageFile != null) {
      var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile('gambar', stream, length,
          filename: basename(imageFile.path));

      request.files.add(multipartFile);
    }

    request.fields['user_id'] = item.userId.toString();
    request.fields['nama_item'] = item.namaItem;

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      return Item.fromJson(json.decode(responseData));
    } else {
      var responseData = await response.stream.bytesToString();
      print('Failed to update item: ${response.statusCode} $responseData');
      throw Exception('Failed to update item');
    }
  }

  Future<void> deleteItem(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/item/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      print('Failed to delete item: ${response.statusCode} ${response.body}');
      throw Exception('Failed to delete item');
    }
  }
  
  // tamuu 
   Future<List<Tamu>> getTamu(String token) async {
     final response = await http.get(
      Uri.parse('$baseUrl/tamu'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((tamu) => Tamu.fromJson(tamu)).toList();
    } else {
      print('Failed to load items: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load items');
    }
  }

  Future<void> createTamu(
    int undangan_id,
    String nama_tamu,
    String email_tamu,
    String nomer_tamu,
    String alamat_tamu,
    String status,
    String kategori,
    String kodeqr,
    String tipe_undangan,
    String token,
) async {
  final url = '$baseUrl/tamu';
  print('Requesting: $url');
  print('Using token: $token');
  print('Request body: ${json.encode({
    'undangan_id': undangan_id,
    'nama_tamu': nama_tamu,
    'email_tamu': email_tamu,
    'nomer_tamu': nomer_tamu,
    'alamat_tamu': alamat_tamu,
    'status': status,
    'kategori': kategori,
    'kodeqr': kodeqr,
    'tipe_undangan': tipe_undangan,
  })}');

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
    'undangan_id': undangan_id,
    'nama_tamu': nama_tamu,
    'email_tamu': email_tamu,
    'nomer_tamu': nomer_tamu,
    'alamat_tamu': alamat_tamu,
    'status': status,
    'kategori': kategori,
    'kodeqr': kodeqr,
    'tipe_undangan': tipe_undangan,
    }),
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode != 200) {
    throw Exception('Failed to create Tamu');
  }
}

  Future<Tamu> updateTamu(int id, Tamu tamu, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tamu/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(tamu.toJson()),
    );

    if (response.statusCode == 200) {
      return Tamu.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update tamu');
    }
  }

  Future<Tamu> showTamu(int id, String token) async {
    final response = await http.get(Uri.parse('$baseUrl/tamu/$id'),
    headers: {
        'Authorization': 'Bearer $token',
    }
    );
    
   if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success']) {
     final jsonResponse = json.decode(response.body);
      final tamuJson = jsonResponse['data']; // Sesuaikan dengan struktur respons API Anda
      return Tamu.fromJson(tamuJson);
    } else {
      throw Exception('Failed to load tamu list: ${jsonResponse['message']}');
    }
  } else {
    print('Failed to load tamu: ${response.statusCode} ${response.body}');
    throw Exception('Failed to load tamu list');
  }
  }

 Future<List<Tamu>> ShowTamubyPetugas(int undangan_id, String token) async {
  final response = await http.get(
    Uri.parse('$baseUrl/tamu/petugas/$undangan_id'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success']) {
      List<dynamic> tamuListJson = jsonResponse['data'];
      List<Tamu> tamuList = tamuListJson.map((json) => Tamu.fromJson(json)).toList();
      return tamuList;
    } else {
      throw Exception('Failed to load tamu list: ${jsonResponse['message']}');
    }
  } else {
    print('Failed to load tamu: ${response.statusCode} ${response.body}');
    throw Exception('Failed to load tamu list');
  }
}


  
  Future<void> deleteTamu(int id, String token) async {
    final response = await http.delete(Uri.parse('$baseUrl/tamu/$id'),
    headers: {
        'Authorization': 'Bearer $token',
    }
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete tamu');
    }
  }

  // profile
  Future<List<Profile>> getProfile(String token) async {
    final response = await http.get(Uri.parse('$baseUrl/profile'),
    headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((profile) => Profile.fromJson(profile)).toList();
    } else {
      print('Failed to load profile: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load profile');
    }
  }

  Future<Profile> createProfile(Profile profile, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/profile/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(profile.toJson()),
    );

    print('Request: ${response.request}');
    print('Response: ${response.body}');

    if (response.statusCode == 201) {
      return Profile.fromJson(jsonDecode(response.body));
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to create profile');
    }
  }

  Future<Profile> showProfile(int userId, String token) async {
    final url = '$baseUrl/profile/$userId';
    print('Requesting URL: $url');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return Profile.fromJson(jsonResponse);
    } else {
      print('Failed to load profile: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load profile');
    }
  }

  Future<Profile> updateProfile(int user_id, Profile profile, String token) async {
   var uri = Uri.parse('$baseUrl/profile/$user_id');
    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Content-Type'] = 'application/json; charset=UTF-8';

    request.fields['_method'] = 'PUT';

    request.fields['user_id'] = profile.userId.toString();
    request.fields['username'] = profile.username;
    request.fields['nomer_telepon'] = profile.nomer_telepon;
    request.fields['alamat'] = profile.alamat;

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      return Profile.fromJson(json.decode(responseData));
    } else {
      var responseData = await response.stream.bytesToString();
      print('Failed to update profile: ${response.statusCode} $responseData');
      throw Exception('Failed to update profile');
    }
  }

  Future<void> deleteProfile(int id, String token) async {
    final response = await http.delete(Uri.parse('$baseUrl/profile/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete Profile');
    }
  }
// Order Verify
 Future<List<OrderVerify>> getOrderVerify(String token) async {
    final response = await http.get(Uri.parse('$baseUrl/verify-order'),
   headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }
  );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((orderverify) => OrderVerify.fromJson(orderverify)).toList();
    } else {
      throw Exception('Failed to load orderverify');
    }
  }

  Future<List<OrderVerify>> getVerifybypetugas(int id_petugas , String token) async {
    final response = await http.get(Uri.parse('$baseUrl/verify-order/petugas/$id_petugas'),
   headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }
  );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((orderverify) => OrderVerify.fromJson(orderverify)).toList();
    } else {
      throw Exception('Failed to load orderverify');
    }
  }

 Future<void> createOrderVerify(int orderId, int profileId, String token) async {
    final url = '$baseUrl/verify-order';
    print('Requesting: $url');
    print('Using token: $token');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'order_id': orderId,
        'profile_id': profileId,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to verify order');
    }
  }

  Future<OrderVerify> showOrderVerify(int id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/verify-order/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return OrderVerify.fromJson(jsonResponse);
    } else {
      print('Failed to load orderverify: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load orderverify');
    }
  }


  Future<OrderVerify> UpdateOrderVerify(int id, OrderVerify orderverify, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/verify-order/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(orderverify.toJson()),
    );

    if (response.statusCode == 200) {
      return OrderVerify.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update orderverify');
    }
  }

  Future<void> DeleteOrderVerify(int id, String token) async {
    final response = await http.delete(Uri.parse('$baseUrl/verify-order/$id'),
    headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete orderverify');
    }
  }


  // Order list
 Future<List<OrderList>> getOrderList(String token) async {
    final response = await http.get(Uri.parse('$baseUrl/order-list'),
   headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }
  );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((orderlist) => OrderList.fromJson(orderlist)).toList();
    } else {
      throw Exception('Failed to load orderlist');
    }
  }



 Future<void> createOrderList(int orderId, int verifyId, int profileId, String kode, String type, String token) async {
  final url = '$baseUrl/order-list';
  print('Requesting: $url');
  print('Using token: $token');

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'order_id': orderId,
      'verify_order_id': verifyId,
      'profile_id': profileId,
      'kode': kode,
      'type': type,
    }),
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode != 200) {
    throw Exception('Failed to create order list');
  }
}
  Future<OrderList> showOrderList(int id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/order-list/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return OrderList.fromJson(jsonResponse);
    } else {
      print('Failed to load orderlist: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load orderlist');
    }
  }
 

Future<List<OrderList>> showPetugasOrderList(int id_petugas, String token) async {
  final response = await http.get(
    Uri.parse('$baseUrl/order-list/petugas/$id_petugas'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body) as List;
    return jsonResponse.map((json) => OrderList.fromJson(json)).toList();
  } else {
    print('Failed to load orderlist: ${response.statusCode} ${response.body}');
    throw Exception('Failed to load orderlist');
  }
}


 Future<List<Order>> showdropdown(int orderlistId, String token) async {
  final response = await http.get(
    Uri.parse('$baseUrl/orderlist/dropdown/$orderlistId'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body) as List;
    return jsonResponse.map((json) => Order.fromJson(json)).toList();
  } else {
    print('Failed to load order dropdown: ${response.statusCode} ${response.body}');
    throw Exception('Failed to load order dropdown');
  }
}

  Future<OrderList> UpdateOrderList(int id, OrderList orderlist, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/order-list/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(orderlist.toJson()),
    );

    if (response.statusCode == 200) {
      return OrderList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update orderlist');
    }
  }

  Future<void> DeleteOrderList(int id, String token) async {
    final response = await http.delete(Uri.parse('$baseUrl/order-list/$id'),
    headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete orderlist');
    }
  }

  // undangan
  Future<List<Undangan>> getUndanganList(String token) async {
    final response = await http.get(Uri.parse('$baseUrl/undangan'),
   headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }
  );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((undangan) => Undangan.fromJson(undangan)).toList();
    } else {
      throw Exception('Failed to load orderlist');
    }
  }


Future<void> createUndanganList(
  int order_id,
  int order_list_id,
  String nama_pengantin_pria,
  String nama_pengantin_wanita,
  String tanggal_pernikahan,
  String lokasi_pernikahan,
  String latitude,
  String longitude,
  String token
) async {
  final url = '$baseUrl/undangan';
  print('Requesting: $url');
  print('Using token: $token');
  print('Request body: ${json.encode({
    'order_id': order_id,
    'order_list_id': order_list_id,
    'nama_pengantin_pria': nama_pengantin_pria,
    'nama_pengantin_wanita': nama_pengantin_wanita,
    'tanggal_pernikahan': tanggal_pernikahan,
    'lokasi_pernikahan': lokasi_pernikahan,
    'latitude': latitude,
    'longitude': longitude,
  })}');

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'order_id': order_id,
      'order_list_id': order_list_id,
      'nama_pengantin_pria': nama_pengantin_pria,
      'nama_pengantin_wanita': nama_pengantin_wanita,
      'tanggal_pernikahan': tanggal_pernikahan,
      'lokasi_pernikahan': lokasi_pernikahan,
      'latitude': latitude,
      'longitude': longitude,
    }),
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode != 200) {
    throw Exception('Failed to create undangan');
  }
}

  Future<Undangan> ShowUndangan(int id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/undangan/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return Undangan.fromJson(jsonResponse);
    } else {
      print('Failed to load orderlist: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load undangan');
    }
  }
 
   Future<Map<String, dynamic>> ShowUndanganbyPetugas(int order_list_id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/undangan/petugas/$order_list_id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse; // Ensure this returns a map with 'success' and 'data' keys
    } else {
      print('Failed to load undangan: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load undangan');
    }
  }


  Future<Undangan> UpdateUndangan(int id, Undangan undangan, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/undangan/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(undangan.toJson()),
    );

    if (response.statusCode == 200) {
      return Undangan.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update undangan');
    }
  }

  Future<void> DeleteUndangan(int id, String token) async {
    final response = await http.delete(Uri.parse('$baseUrl/undangan/$id'),
    headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete Undangan');
    }
  }
}
