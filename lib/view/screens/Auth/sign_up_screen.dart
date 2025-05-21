import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/Auth/forget_password_provider.dart';
import 'package:food2go_app/view/widgets/show_top_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/view/screens/Auth/login_screen.dart';
import 'package:country_code_picker/country_code_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  String countryCode = '+20';

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
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
                      const Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Center(
                        child: Text(
                          'Create a new Account',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: fNameController,
                        decoration: InputDecoration(
                          labelText: ' First name',
                          labelStyle: const TextStyle(color: Colors.black45),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF7F7F7),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: lNameController,
                        decoration: InputDecoration(
                          labelText: ' Last name',
                          labelStyle: const TextStyle(color: Colors.black45),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF7F7F7),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7F7),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          children: [
                            CountryCodePicker(
                              onChanged: (CountryCode code) {
                                setState(() {
                                  countryCode = code.dialCode!;
                                });
                              },
                              initialSelection: 'EG',
                              favorite: const ['EG'],
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                              padding: EdgeInsets.zero,
                              textStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            Container(
                              height: 30,
                              width: 1,
                              color: Colors.grey[300],
                            ),
                            Expanded(
                              child: TextField(
                                controller: phoneController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Phone number',
                                  labelStyle: TextStyle(color: Colors.black45),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: ' Email',
                          labelStyle: const TextStyle(color: Colors.black45),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF7F7F7),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: ' Password',
                          labelStyle: const TextStyle(color: Colors.black45),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF7F7F7),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 16.0),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: confPasswordController,
                        obscureText: !isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          labelText: ' Confirm Password',
                          labelStyle: const TextStyle(color: Colors.black45),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF7F7F7),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 16.0),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isConfirmPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                isConfirmPasswordVisible =
                                    !isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                setState(() {
                                  isLoading = true;
                                });
                                final otpServices = Provider.of<OtpProvider>(
                                    context,
                                    listen: false);
                                if (fNameController.text.isEmpty ||
                                    lNameController.text.isEmpty ||
                                    phoneController.text.isEmpty ||
                                    emailController.text.isEmpty ||
                                    passwordController.text.isEmpty ||
                                    confPasswordController.text.isEmpty) {
                                  showTopSnackBar(
                                      context,
                                      'Please fill all the fields',
                                      Icons.warning_outlined,
                                      maincolor,
                                      const Duration(seconds: 4));
                                } else {
                                  final fullPhoneNumber =
                                      '$countryCode${phoneController.text}';
                                  otpServices.signUpUserOTP(
                                    context,
                                    fName: fNameController.text,
                                    lName: lNameController.text,
                                    email: emailController.text,
                                    phone: fullPhoneNumber,
                                    password: passwordController.text,
                                    confPassword: confPasswordController.text,
                                  );
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: maincolor,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                color: Colors.white,
                              ))
                            : const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("I already have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(color: maincolor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
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
