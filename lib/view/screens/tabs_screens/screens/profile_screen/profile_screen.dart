// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/controllers/address/get_address_provider.dart';
import 'package:food2go_app/controllers/profile/get_profile_provider.dart';
import 'package:food2go_app/generated/l10n.dart';
import 'package:food2go_app/view/screens/Auth/login_screen.dart';
import 'package:food2go_app/view/screens/my_orders/my_orders_screen.dart';
import 'package:food2go_app/view/screens/tabs_screens/screens/profile_screen/select_lang_screen.dart';
import 'package:provider/provider.dart';
import 'address_screen.dart';
import 'personal_info.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<GetProfileProvider>(context);
    final authServices = Provider.of<LoginProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text(S.of(context).Profile)),
          automaticallyImplyLeading: false,
        ),
        body: profileProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : authServices.token == null
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Login to view profile"),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: maincolor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Login'),
                      ),
                    ],
                  ))
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                                profileProvider.userProfile!.imageLink ??
                                    'assets/images/delivery.png'),
                            backgroundColor: Colors.grey[200],
                            onBackgroundImageError: (_, __) =>
                                const Icon(Icons.error),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${S.of(context).Welcome} ${profileProvider.userProfile!.name}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildProfileOption(
                            icon: Icons.person_outline,
                            label: S.of(context).personal_info,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PersonalInfo(),
                                ),
                              );
                            },
                          ),
                          _buildProfileOption(
                            icon: Icons.location_on_outlined,
                            label: S.of(context).addresses,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddressScreen(),
                                ),
                              );
                            },
                          ),
                          _buildProfileOption(
                            icon: Icons.shopping_bag_outlined,
                            label: S.of(context).my_orders,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyOrderScreen(),
                                ),
                              );
                            },
                          ),
                          _buildProfileOption(
                            icon: Icons.language,
                            label: S.of(context).select_language,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SelectLangScreen(),
                                ),
                              );
                            },
                          ),
                          _buildProfileOption(
                            icon: Icons.logout,
                            label: S.of(context).log_out,
                            onTap: () {
                              final addressProvider =
                                  Provider.of<AddressProvider>(context,
                                      listen: false);
                              addressProvider.selectedAddressId = null;
                              addressProvider.selectedBranchId = null;
                              addressProvider.resetSelectedAddresses();
                              Provider.of<LoginProvider>(context, listen: false)
                                  .logout(context);
                            },
                          ),
                          _buildProfileOption(
                            icon: Icons.delete_outline,
                            label: S.of(context).delete_account,
                            onTap: () {
                              Provider.of<LoginProvider>(context, listen: false)
                                  .deleteAccount(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(icon, color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[700], size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
