import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food2go_app/constants/strings.dart';
import 'package:food2go_app/controllers/lang_services_controller.dart';
import 'package:food2go_app/models/categories/categories_model.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CategoriesProvider with ChangeNotifier {
  List<Category> _categories = [];
  List<Category> get categories => _categories;
  Future<void> fetchCategories(BuildContext context) async {
    try {
      final langProvider = Provider.of<LangServices>(context, listen: false);
      final selectedLang = langProvider.selectedLang;

      final String url = '$categoriesUrl?locale=$selectedLang';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        Categories categories = Categories.fromJson(responseData);
        _categories =
            categories.categories.map((e) => Category.fromJson(e)).toList();
        notifyListeners();
      } else {
        log('Fail with status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error in fetching categories: $e');
    }
  }
}
