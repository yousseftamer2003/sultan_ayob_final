// ignore_for_xxxxxxxxxxe: use_build_context_synchronously

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/constants/strings.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/controllers/address/get_address_provider.dart';
import 'package:food2go_app/controllers/lang_services_controller.dart';
import 'package:food2go_app/models/categories/product_model.dart';
import 'package:food2go_app/view/screens/checkout/order_completed_screen.dart';
import 'package:food2go_app/view/screens/checkout/order_failed_screen.dart';
import 'package:food2go_app/view/screens/checkout/payment_web_view.dart';
import 'package:food2go_app/view/widgets/show_top_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  List<Product> _popularProducts = [];
  List<Product> get popularProducts => _popularProducts;

  List<Product> _favorites = [];
  List<Product> get favorites => _favorites;

  List<Product> _discounts = [];
  List<Product> get discounts => _discounts;

  List<Product> _cart = [];
  List<Product> get cart => _cart;

  List<Product> _filteredProducts = [];
  List<Product> get filteredProducts => _filteredProducts;

  static const String _cartKey = 'cart_items';

  double _totalPrice = 0.0;
  double _totalTax = 0.0;

  double get totalPrice {
    _totalPrice = 0.0;
    double defaultPrice;
    for (var item in cart) {
      defaultPrice = item.price / item.quantity;
      defaultPrice += (defaultPrice * (item.tax.amount / 100));
      if (item.discountId.isNotEmpty) {
        defaultPrice -= (defaultPrice * (item.discount.amount / 100));
      }
      _totalPrice += defaultPrice * item.quantity;
      for (var extra in item.extra) {
        // _totalPrice += extra.price * extra.extraQuantity;
      }
    }
    return _totalPrice;
  }

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  Future<void> clearCart() async {
    _cart.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
    notifyListeners();
  }


  Future<void> fetchProducts(BuildContext context,
      {int? userId, int? branchId, int? addressId}) async {
    try {
      final langProvider = Provider.of<LangServices>(context, listen: false);
      final selectedLang = langProvider.selectedLang;

      String url = '$categoriesUrl?locale=$selectedLang';

      if (branchId != null) {
        url = '$url&branch_id=$branchId';
      } else if (addressId != null) {
        url = '$url&address_id=$addressId';
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        log(url);
        Map<String, dynamic> responseData = jsonDecode(response.body);
        Products products = Products.fromJson(responseData);
        _products = products.products.map((e) => Product.fromJson(e)).toList();
        _popularProducts = _products.where((e) => e.reccomended == 1).toList();
        _favorites = _products.where((e) => e.isFav).toList();
        _discounts = _products.where((e) => e.discountId.isNotEmpty).toList();
        log('discounts: ${_discounts.map((e) => e.name)}');
        notifyListeners();
      } else {
        log('Failed with status code: ${response.statusCode}');
        log('Failed with status body product: ${response.body}');
      }
    } catch (e) {
      log('Error in fetch products: $e');
    }
  }


  Future<void> postCart(BuildContext context,
      {required List<Product> products,
      String? receipt,
      String? notes,
      required String date,
      int? branchId,
      required double totalTax,
      int? addressId,
      required int paymentMethodId,
      required String orderType,
      required double zonePrice,
      double? totalDiscount,
      int? secheduleslotid,
      int confirmOrder = 0}) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String token = loginProvider.token!;

    final Map<String, dynamic> requestBody = {
      'confirm_order': confirmOrder,
      'sechedule_slot_id': secheduleslotid,
      'locale': 'ar',
      'notes': notes,
      'date': date,
      'payment_method_id': paymentMethodId,
      'receipt': receipt,
      'branch_id': branchId,
      'amount': totalPrice + zonePrice,
      'total_tax': totalTax,
      'total_discount': totalDiscount,
      'address_id': addressId,
      'order_type': orderType,
      'delivery_price': zonePrice,
      'products': products
          .map((product) => {
                'product_id': product.id,
                'count': product.quantity,
                'addons': product.addons
                    .map((addon) =>
                        {'addon_id': addon.id, 'count': addon.selectedQuantity})
                    .toList(),
                'variation': product.variations
                    .map((variation) => {
                          'variation_id': variation.id,
                          'option_id':
                              variation.options.map((e) => e.id).toList(),
                        })
                    .toList(),
                'extra_id': product.extra.map((e) => e.id).toList(),
                'exclude_id': product.excludes.map((e) => e.id).toList(),
              })
          .toList(),
    };

    log('Request Data: ${jsonEncode(requestBody)}');

    try {
      final response = await http.post(
        Uri.parse(postOrder),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData.containsKey('paymentLink')) {
          final String paymentLink = responseData['paymentLink'];
          final int orderId = responseData['success'];
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => PaymentWebView(
                url: paymentLink,
                orderId: orderId,
              ),
            ),
          );
          if (result) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => OrderFailedScreen(orderId: orderId)));
          }
        } else {
          final int orderId = responseData['success'];
          clearCart();
          final addressProvider =
              Provider.of<AddressProvider>(context, listen: false);
          addressProvider.selectedAddressId = null;
          addressProvider.selectedBranchId = null;
          addressProvider.resetSelectedAddresses();
          addressProvider.notifyListeners();

          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => OrderCompletedScreen(orderId: orderId)));
        }
      } else if (response.statusCode == 510) {
        final bool shouldConfirm = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              title: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "You have already placed an order",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              content: const Text(
                "You already have a pending order. Do you want to continue with this order anyway?",
                style: TextStyle(fontSize: 16),
              ),
              actionsPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                  child: const Text("Cancel",
                      style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: maincolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                  child:
                      const Text("OK", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );

        if (shouldConfirm == true) {
          await postCart(
            context,
            products: products,
            receipt: receipt,
            notes: notes,
            date: date,
            branchId: branchId,
            totalTax: totalTax,
            addressId: addressId,
            paymentMethodId: paymentMethodId,
            orderType: orderType,
            zonePrice: zonePrice,
            totalDiscount: totalDiscount,
            secheduleslotid: secheduleslotid,
            confirmOrder: 1,
          );
        }
      } else if (response.statusCode == 403) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Restaurant is closed"),
            backgroundColor: maincolor,
          ),
        );
      } else {
        log(response.body);
        log('Failed to post order: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to place order: ${response.statusCode}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      log('Error in post order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    if (_searchQuery.isEmpty) {
      _filteredProducts = [];
    } else {
      _filteredProducts = _products
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void increaseProductQuantity(Product product) {
    double defaultPrice = product.price / product.quantity;
    product.quantity++;
    product.price = defaultPrice * product.quantity;
    saveCart();
    notifyListeners();
  }

  void decreaseProductQuantity(Product product) {
    if (product.quantity > 1) {
      double defaultPrice = product.price / product.quantity;

      product.quantity--;
      product.price = defaultPrice * product.quantity;

      saveCart();
      notifyListeners();
    }
  }

  void increaseExtraQuantity(int index, int extraIndex) {
    cart[index].extra[extraIndex].extraQuantity++;
    notifyListeners();
  }

  void decreaseExtraQuantity(int index, int extraIndex) {
    if (cart[index].extra[extraIndex].extraQuantity > 1) {
      cart[index].extra[extraIndex].extraQuantity--;
      notifyListeners();
    }
  }

  double getTotalTax(List<Product> cartProducts) {
    for (var e in cartProducts) {
      _totalTax += e.tax.amount;
    }
    return _totalTax;
  }

  double getTotalTaxAmount(List<Product> cartProducts) {
    double taxAmount = 0;
    for (var e in cartProducts) {
      taxAmount = (e.price * (e.tax.amount / 100));
    }
    return taxAmount;
  }

  List<Product> getProductsByCategory(int categoryId) {
    return _products
        .where((product) => product.categoryId == categoryId)
        .toList();
  }

  List<Product> getFilteredProducts(
      int? categoryId, double priceStart, double priceEnd) {
    return _products.where((product) {
      final matchesCategory =
          categoryId == null || product.categoryId == categoryId;
      final matchesPrice =
          product.price >= priceStart && product.price <= priceEnd;
      return matchesCategory && matchesPrice;
    }).toList();
  }

  List<Extra> getExtras(Product product, int selectedVariation) {
    if (product.extra.isEmpty) {
      List<Extra> extras = [];
      if (selectedVariation == -1) {
        return [];
      } else {
        final options = product.variations[selectedVariation].options;
        for (var e in options) {
          extras.addAll(e.extra);
        }
        return extras;
      }
    } else {
      return product.extra;
    }
  }

  Future<void> makeFavourites(BuildContext context, int fav, int id) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String token = loginProvider.token!;

    try {
      final response = await http.put(
        Uri.parse('$makeFav$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'favourite': fav}),
      );

      if (response.statusCode == 200) {
        _updateFavoritesStatus(id, fav);

        final message = fav == 1 ? 'Added to Favorites!' : 'Item removed';
        final icon = fav == 1 ? Icons.favorite : Icons.heart_broken;

        showTopSnackBar(
            context, message, icon, maincolor, const Duration(seconds: 4));
      } else {
        log('Failed with status code: ${response.statusCode}');
        showTopSnackBar(context, 'Failed to update favorite status.',
            Icons.error, Colors.red, const Duration(seconds: 4));
      }
    } catch (e) {
      log('Error in making fav: $e');
      showTopSnackBar(context, 'An error occurred. Please try again later.',
          Icons.error, Colors.red, const Duration(seconds: 4));
    }
  }

  void _updateFavoritesStatus(int id, int fav) {
    bool isFavorite = (fav == 1);

    for (var product in _products) {
      if (product.id == id) {
        product.isFav = isFavorite;
      }
    }
    _favorites = _products.where((product) => product.isFav).toList();
    notifyListeners();
  }

  Future<void> addToCart(Product product) async {
    _cart.add(product);
    await saveCart();
    notifyListeners();
  }

  Future<void> removeFromCart(int index) async {
    _cart.removeAt(index);
    await saveCart();
    notifyListeners();
  }

  Future<void> saveCart() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String cartJson =
        jsonEncode(_cart.map((item) => item.toJson()).toList());
    await prefs.setString(_cartKey, cartJson);
    log('Cart saved: $cartJson');
  }

  Future<void> loadCart() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? cartJson = prefs.getString(_cartKey);
    if (cartJson != null) {
      _cart =
          List.from(jsonDecode(cartJson).map((item) => Product.fromJson(item)));
    } else {
      _cart = [];
    }
    notifyListeners();
  }
}
