// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/constants/strings.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/models/address/user_address_model.dart';
import 'package:food2go_app/view/widgets/show_top_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddressProvider with ChangeNotifier {
  List<Address> _addresses = [];
  List<Zone> _zones = [];
  List<BranchStarter> _branchStarters = [];

  bool _isLoading = false;
  String? _errorMessage;

  int? selectedAddressId;
  int? selectedBranchId;
  double _selectedZonePrice = 0.0;

  List<Address> get addresses => _addresses;
  List<Zone> get zones => _zones;
  List<BranchStarter> get branchStarters => _branchStarters;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get selectedZonePrice => _selectedZonePrice;

  void selectAddress(int addressId) {
    selectedAddressId = addressId;

    try {
      final selectedAddress = _addresses.firstWhere(
        (address) => address.id == addressId,
      );
      _selectedZonePrice = selectedAddress.zone.price;
    } catch (e) {
      _selectedZonePrice = 0.0;
      log('Error selecting address: $e');
    }
    notifyListeners();
  }

  void resetSelectedAddresses() {
    _selectedZonePrice = 0.0;
    notifyListeners();
  }

  Future<void> fetchAddresses(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final String token = loginProvider.token ?? '';

      final response = await http.get(
        Uri.parse('https://$domain/customer/address'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        _addresses = (data['addresses'] ?? [])
            .map<Address>((item) => Address.fromJson(item))
            .toList();

        _zones = (data['zones'] ?? [])
            .map<Zone>((item) => Zone.fromJson(item))
            .toList();

        _branchStarters = (data['branches'] ?? [])
            .map<BranchStarter>((item) => BranchStarter.fromJson(item))
            .toList();

        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to load addresses and zones';
        log('Error ${response.statusCode}: ${response.body}');
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      log('Exception in fetchAddresses: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear selected address (optional: call on logout)
  void clearSelectedAddress() {
    selectedAddressId = null;
    _selectedZonePrice = 0.0;
    notifyListeners();
  }

  Future<void> addAddress({
    required BuildContext context,
    required int zoneId,
    required String mapLink,
    required String address,
    required String street,
    required String buildingNum,
    required String floorNum,
    required String apartment,
    String? additionalData,
    required String type,
  }) async {
    _isLoading = true;
    notifyListeners();

    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String token = loginProvider.token!;

    try {
      final response = await http.post(
        Uri.parse(
            'https://sultanayubbcknd.food2go.online/customer/address/add'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'zone_id': zoneId,
          'address': address,
          'street': street,
          'building_num': buildingNum,
          'floor_num': floorNum,
          'apartment': apartment,
          'additional_data': additionalData,
          'type': type,
          'map': mapLink
        }),
      );

      if (response.statusCode == 200) {
        log(response.body);
        await fetchAddresses(context);
        showTopSnackBar(context, 'Your address was saved successfully.',
            Icons.check, maincolor, const Duration(seconds: 2));
        Navigator.pop(context);
      } else {
        log(response.body);
        _errorMessage = 'Failed to add address. Please try again.';
      }
    } catch (error) {
      log(error.toString());
      _errorMessage = 'An error occurred: $error';
    } finally {
      _isLoading = false;
      if (context.mounted) {
        notifyListeners();
      }
    }
  }

  Future<void> deleteAddress(String token, int addressId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.delete(
        Uri.parse(
            'https://sultanayubbcknd.food2go.online/customer/address/delete/$addressId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _addresses.removeWhere((address) => address.id == addressId);
        notifyListeners(); // Trigger update in UI
      } else {
        _errorMessage = 'Failed to delete address. Please try again.';
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
