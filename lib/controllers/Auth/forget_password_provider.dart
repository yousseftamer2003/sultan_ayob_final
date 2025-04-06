// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/constants/strings.dart';
import 'package:food2go_app/view/screens/Auth/code_verification_screen.dart';
import 'package:food2go_app/view/widgets/show_top_snackbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> sendOtpCode(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final url = Uri.parse('https://$domain/customer/otp/create_code');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        // Handle success response
        log("OTP sent successfully");
      } else {
        // Handle error response
        _errorMessage = 'Failed to send OTP: ${response.statusCode}';
        log(_errorMessage.toString());
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      log(_errorMessage.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyOtpCode(String email, String otpCode) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final url =
        Uri.parse('https://sultanayubbcknd.food2go.online/customer/otp/check_code');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'code': otpCode}),
      );

      if (response.statusCode == 200) {
        log("OTP verified successfully");
      } else {
        log(response.body.toString());
        _errorMessage = 'Failed to verify OTP: ${response.statusCode}';
        log(_errorMessage.toString());
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      log(_errorMessage.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changePassword(
      String email, String otpCode, String newPassword) async {
    final url =
        Uri.parse('https://sultanayubbcknd.food2go.online/customer/otp/change_password');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'code': otpCode,
          'password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        log("Password changed successfully");
      } else {
        _errorMessage = 'Failed to change password: ${response.statusCode}';
        log(_errorMessage.toString());
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      log(_errorMessage.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  int _smsCode = 0;
  int get smsCode => _smsCode;

  Future<void> signUpUserOTP(
    BuildContext context, {
    required String fName,
    required String lName,
    required String email,
    required String phone,
    required String password,
    required String confPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://sultanayubbcknd.food2go.online/api/user/auth/signup/phone_code'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone': phone}),
      );
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        _smsCode = responseData['code'];
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => CodeVerificationScreen(
                  fname: fName,
                  lname: lName,
                  emailSignUp: email,
                  phone: phone,
                  password: password,
                  confPassword: confPassword,
                )));
      } else {
        showTopSnackBar(context, 'someThing went wrong', Icons.warning_outlined,
            maincolor, const Duration(seconds: 4));
        log('Failed to send code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error in sending code: $e');
    }
  }
}
