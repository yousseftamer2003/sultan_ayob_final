// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/Auth/forget_password_provider.dart';
import 'package:food2go_app/controllers/Auth/sign_up_provider.dart';
import 'package:food2go_app/view/widgets/show_top_snackbar.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:pinput/pinput.dart';
import 'package:food2go_app/view/screens/Auth/new_password_screen.dart';
import 'package:food2go_app/constants/colors.dart';

class CodeVerificationScreen extends StatefulWidget {
  final String? email;
  final String? phone;
  final String? fname;
  final String? lname;
  final String? password;
  final String? confPassword;
  final String? emailSignUp;
  const CodeVerificationScreen({super.key, this.email, this.phone, this.fname, this.lname, this.password, this.confPassword, this.emailSignUp});

  @override
  State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  final TextEditingController codeController = TextEditingController();
  int _seconds = 180;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void emailVerification() async {
    final otpProvider = Provider.of<OtpProvider>(context,listen: false);
    await otpProvider.verifyOtpCode(widget.email!, codeController.text);
    if (otpProvider.errorMessage == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewPasswordScreen(
            email: widget.email!,
            code: codeController.text,
          ),
        ),
      );
    } else {
      showTopSnackBar(context, otpProvider.errorMessage!, Icons.warning, maincolor, const Duration(seconds: 3));
    }
  }

  Future<void> mobishastraVerification() async {
    final otpServices = Provider.of<OtpProvider>(context,listen: false);
    if (otpServices.smsCode == int.parse(codeController.text)) {
      showTopSnackBar(context, 'OTP verified successfully', Icons.check,
          maincolor, const Duration(seconds: 3));
      await Provider.of<SignUpProvider>(context,listen: false).signUpUser(
              fName: widget.fname!,
              lName: widget.lname!,
              email: widget.emailSignUp!,
              phone: widget.phone!,
              password: widget.password!,
              confPassword: widget.confPassword!,
              context: context);
    }else{
      showTopSnackBar(context, 'Something Went Wrong with OTP', Icons.warning_outlined,
          maincolor, const Duration(seconds: 3));
    }
  }

  String getFormattedTime() {
    int minutes = _seconds ~/ 60;
    int seconds = _seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}m";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final otpProvider = Provider.of<OtpProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/Frame.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.10,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                'Elsultan Ayub',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(45.0)),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          widget.email == null
                              ? 'Check your SMS'
                              : 'Check your email',
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          'We sent a reset link to ${widget.email ?? widget.phone} Enter the 4-digit code mentioned in the email.',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Pinput(
                        length: 5,
                        controller: codeController,
                        defaultPinTheme: PinTheme(
                          width: 56,
                          height: 56,
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        focusedPinTheme: PinTheme(
                          width: 56,
                          height: 56,
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: maincolor,
                            ),
                          ),
                        ),
                        onCompleted: (pin) {
                          print('Completed: $pin');
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          getFormattedTime(),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Didn't receive the code?",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              if (_seconds == 0) {
                                otpProvider.sendOtpCode('contact@gmail.com');
                                setState(() {
                                  _seconds = 180;
                                });
                                startTimer();
                              }
                            },
                            child: const Text(
                              "Re-Send",
                              style: TextStyle(
                                fontSize: 16,
                                color: maincolor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (widget.email != null) {
                            emailVerification();
                          } else {
                            mobishastraVerification();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: maincolor,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: otpProvider.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Verify code',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
