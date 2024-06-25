// rest_api.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

import 'package:myapp/app/models/managementuser.dart';
import '../models/item.dart';
import '../models/tamu.dart';
import '../models/order.dart';

class ApiService {
  // final String baseUrl = "https://weddingcheck.polinema.web.id/api";
  final String baseUrl = "https://8613-36-85-69-134.ngrok-free.app/api";

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
    final response = await http.get(Uri.parse('$baseUrl/orders'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((order) => Order.fromJson(order)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<Order> createOrder(Order order, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(order.toJson()),
    );

    if (response.statusCode == 201) {
      return Order.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create order');
    }
  }

  Future<Order> updateOrder(int id, Order order, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/orders/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
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
    final response = await http.delete(Uri.parse('$baseUrl/orders/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete order');
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

   Future<Item> updateItem(int id, Item item, String token, File? imageFile) async {
    var uri = Uri.parse('$baseUrl/item/$id');
    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Content-Type'] = 'multipart/form-data';

    // Add the _method field to override the HTTP method
    request.fields['_method'] = 'PUT';

    if (imageFile != null) {
      // Attach the image file
      var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile('gambar', stream, length,
          filename: basename(imageFile.path));

      request.files.add(multipartFile);
    }

    // Add other fields
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
   Future<List<Tamu>> getTamus() async {
    final response = await http.get(Uri.parse('$baseUrl/tamus'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((tamu) => Tamu.fromJson(tamu)).toList();
    } else {
      throw Exception('Failed to load tamus');
    }
  }

  Future<Tamu> createTamu(Tamu tamu) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tamus'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(tamu.toJson()),
    );

    if (response.statusCode == 201) {
      return Tamu.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create tamu');
    }
  }

  Future<Tamu> updateTamu(int id, Tamu tamu) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tamus/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(tamu.toJson()),
    );

    if (response.statusCode == 200) {
      return Tamu.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update tamu');
    }
  }

  Future<void> deleteTamu(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/tamus/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete tamu');
    }
  }
}
