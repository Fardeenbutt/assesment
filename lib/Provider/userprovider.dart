import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Model/usermodel.dart';

class UserProvider with ChangeNotifier {
  final List<Result> _users = [];
  bool _isLoading = false;
  int _currentPage = 1;

  List<Result> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> fetchUsers({bool loadMore = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final url = 'https://randomuser.me/api/?page=$_currentPage&results=10';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = Welcome.fromJson(jsonDecode(response.body));

        if (loadMore) {
          _users.addAll(data.results);
        } else {
          _users.clear();
          _users.addAll(data.results);
        }

        _currentPage++;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (error) {
      debugPrint('Error fetching users: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
