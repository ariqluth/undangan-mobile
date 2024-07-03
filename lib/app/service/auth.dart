import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';
import '../models/registeruser.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  RegisterUser? _userregister;

  User? get user => _user;
  RegisterUser? get registeruser => _userregister;

  String? get token => _user?.token;

  Future<void> login(String email, String password) async {
    // final url = Uri.parse('https://weddingcheck.polinema.web.id/api/auth/login');
    final url = Uri.parse('https://6751-2001-448a-5040-4bfb-6812-d32-3b10-4316.ngrok-free.app/api/auth/login');
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Response Data: $responseData');
      _user = User.fromJson(responseData['data']);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('user', json.encode(_user!.toJson()));
      notifyListeners();
    } else {
      final responseData = json.decode(response.body);
      throw Exception(responseData['message'] ?? 'Failed to login');
    }
  }

  Future<void> register(String name, String email, String password, String role, String device) async {
    // final url = Uri.parse('https://weddingcheck.polinema.web.id/api/auth/register');
    final url = Uri.parse('https://6751-2001-448a-5040-4bfb-6812-d32-3b10-4316.ngrok-free.app/api/auth/register');
    final response = await http.post(
      url,
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'role': role,
        'device': device,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final userData = responseData['user'];
      userData['token'] = responseData['token'];
      _userregister = RegisterUser.fromJson(userData);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('user', json.encode(_user!.toJson()));
      notifyListeners();
    } else {
      final responseData = json.decode(response.body);
      throw Exception(responseData['message'] ?? 'Failed to register');
    }
  }

  Future<void> logout() async {
    // final url = Uri.parse('https://weddingcheck.polinema.web.id/api/auth/logout');
    final url = Uri.parse('https://6751-2001-448a-5040-4bfb-6812-d32-3b10-4316.ngrok-free.app/api/auth/logout');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${_user!.token}',
      },
    );

    if (response.statusCode == 200) {
      _user = null;
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('user');
      notifyListeners();
    } else {
      final responseData = json.decode(response.body);
      throw Exception(responseData['message'] ?? 'Failed to logout');
    }
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('user')) {
      return;
    }

    final extractedUserData = json.decode(prefs.getString('user')!) as Map<String, dynamic>;
    _user = User.fromJson(extractedUserData);
    notifyListeners();
  }
}
