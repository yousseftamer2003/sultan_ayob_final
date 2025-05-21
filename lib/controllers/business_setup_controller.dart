import 'dart:convert';
import 'dart:developer';
import 'package:food2go_app/models/business_setup.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class BusinessSetupController with ChangeNotifier {
  BusinessSetup? _businessSetup;
  BusinessSetup? get businessSetup => _businessSetup;
  Future<void> fetchBusinessSetup(BuildContext context,
      {int? branchId, int? addressId}) async {
    try {
      String url = 'https://sultanayubbcknd.food2go.online/api/business_setup';

      if (branchId != null) {
        url = '$url?branch_id=$branchId';
      } else if (addressId != null) {
        url = '$url?address_id=$addressId';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      log(url);

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
