// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/profile/edit_profile_provider.dart';
import 'package:food2go_app/controllers/profile/get_profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController phone2Controller = TextEditingController();

  File? _selectedImage;
  bool _dataInitialized = false;

  Future<void> _pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _fetchUserProfile() async {
    await Provider.of<GetProfileProvider>(context, listen: false)
        .fetchUserProfile(context);
  }

  void _initializeFormData() {
    final profilesProvider =
        Provider.of<GetProfileProvider>(context, listen: false);
    if (profilesProvider.userProfile != null && !_dataInitialized) {
      fnameController.text = profilesProvider.userProfile!.fName ?? '';
      lnameController.text = profilesProvider.userProfile!.lName ?? '';
      emailController.text = profilesProvider.userProfile!.email ?? '';
      phoneController.text = profilesProvider.userProfile!.phone ?? '';
      passController.text = profilesProvider.userProfile!.phone2 ?? '';
      passController.text = '';

      setState(() {
        _dataInitialized = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchUserProfile();
      _initializeFormData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeFormData();
  }

  @override
  void dispose() {
    fnameController.dispose();
    lnameController.dispose();
    emailController.dispose();
    passController.dispose();
    phoneController.dispose();
    phone2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profilesProvider = Provider.of<GetProfileProvider>(context);

    if (profilesProvider.userProfile == null) {
      return Scaffold(
        appBar: buildAppBar(context, 'Edit profile'),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (!_dataInitialized) {
      _initializeFormData();
    }

    return WillPopScope(
      onWillPop: () async {
        await _fetchUserProfile();
        return true;
      },
      child: Scaffold(
        appBar: buildAppBar(context, 'Edit profile'),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!) as ImageProvider
                                : (profilesProvider.userProfile?.imageLink !=
                                        null
                                    ? NetworkImage(profilesProvider
                                        .userProfile!.imageLink!)
                                    : const AssetImage(
                                        'assets/default_avatar.png')),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: CircleAvatar(
                              backgroundColor: maincolor,
                              radius: 16,
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (_) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading:
                                                const Icon(Icons.camera_alt),
                                            title: const Text('Take a photo'),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              _pickImageFromCamera();
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.photo),
                                            title: const Text(
                                                'Choose from gallery'),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              _pickImageFromGallery();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Icon(Icons.edit,
                                    color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${profilesProvider.userProfile?.fName ?? ''} ${profilesProvider.userProfile?.lName ?? ''}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextField('First Name', fnameController),
                const SizedBox(height: 16),
                _buildTextField('Last Name', lnameController),
                const SizedBox(height: 16),
                _buildTextField('Email', emailController),
                const SizedBox(height: 16),
                _buildTextField('Phone', phoneController),
                const SizedBox(height: 16),
                _buildTextField('Phone 2', phone2Controller),
                const SizedBox(height: 24),
                TextField(
                  controller: passController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Leave blank to keep current password',
                    labelStyle: const TextStyle(color: Colors.black45),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await Provider.of<EditProfileProvider>(context,
                            listen: false)
                        .postProfileUpdate(
                      context,
                      firstName: fnameController.text,
                      lastName: lnameController.text,
                      email: emailController.text,
                      phone: phoneController.text,
                      password: passController.text.isNotEmpty
                          ? passController.text
                          : null,
                      phone2: phoneController.text,
                      imagePath: _selectedImage?.path,
                    );
                    await _fetchUserProfile();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Profile updated successfully')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: maincolor,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black45),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}
