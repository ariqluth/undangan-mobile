import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/app/models/managementuser.dart';
import '../models/item.dart';
import '../models/tamu.dart';
import '../models/order.dart';

class ApiService {
  final String baseUrl = "https://weddingcheck.polinema.web.id/api";

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
 Future<List<Order>> getOrders() async {
    final response = await http.get(Uri.parse('$baseUrl/orders'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((order) => Order.fromJson(order)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<Order> createOrder(Order order) async {
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

  Future<Order> updateOrder(int id, Order order) async {
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

  Future<void> deleteOrder(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/orders/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete order');
    }
  }
// items
  Future<List<Item>> getItems() async {
    final response = await http.get(Uri.parse('$baseUrl/items'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Item.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<Item> createItem(Item item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/items'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(item.toJson()),
    );

    if (response.statusCode == 201) {
      return Item.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create item');
    }
  }

  Future<Item> updateItem(int id, Item item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/items/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(item.toJson()),
    );

    if (response.statusCode == 200) {
      return Item.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update item');
    }
  }

  Future<void> deleteItem(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/items/$id'));

    if (response.statusCode != 204) {
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
