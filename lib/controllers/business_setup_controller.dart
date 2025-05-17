import 'dart:convert';
import 'dart:developer';
import 'package:food2go_app/models/business_setup.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class BusinessSetupController with ChangeNotifier {
  BusinessSetup? _businessSetup;
  BusinessSetup? get businessSetup => _businessSetup;

  Future<void> fetchBusinessSetup(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('https://sultanayubbcknd.food2go.online/api/business_setup'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _businessSetup = BusinessSetup.fromJson(responseData);

        notifyListeners();
      } else {
        log('Failed to fetch business setup with StatusCode: ${response.statusCode}');
        log('Failed to fetch business setup with body: ${response.body}');
      }
    } catch (e) {
      log('Error fetching business setup: $e');
    }
  }
}
