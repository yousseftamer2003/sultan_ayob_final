import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food2go_app/models/time_schedule_model.dart';
import 'package:http/http.dart' as http;

class ScheduleProvider with ChangeNotifier {
  List<ScheduleItem> _scheduleList = [];
  bool _isLoading = false;
  String? _error;

  List<ScheduleItem> get scheduleList => _scheduleList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchScheduleList() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final url = Uri.parse(
        'https://sultanayubbcknd.food2go.online/customer/home/schedule_list');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final data = ScheduleResponse.fromJson(jsonResponse);
        _scheduleList = data.scheduleList;
      } else {
        _error = 'Failed to load data: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'An error occurred: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
