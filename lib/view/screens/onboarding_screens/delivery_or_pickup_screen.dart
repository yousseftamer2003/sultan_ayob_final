import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/address/get_address_provider.dart';
import 'package:food2go_app/controllers/business_setup_controller.dart';
import 'package:food2go_app/view/screens/onboarding_screens/widget/delivery_content.dart';
import 'package:food2go_app/view/screens/onboarding_screens/widget/option_container_widget.dart';
import 'package:food2go_app/view/screens/onboarding_screens/widget/pickup_content.dart';
import 'package:food2go_app/view/screens/tabs_screen.dart';
import 'package:food2go_app/view/widgets/show_top_snackbar.dart';
import 'package:provider/provider.dart';

class DeliveryOrPickupScreen extends StatefulWidget {
  const DeliveryOrPickupScreen({super.key});

  @override
  State<DeliveryOrPickupScreen> createState() => _DeliveryOrPickupScreenState();
}

class _DeliveryOrPickupScreenState extends State<DeliveryOrPickupScreen> {
  int selectedIndex = 0;
  final List<String> texts = ['Delivery', 'pickup'];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddressProvider>(context, listen: false)
          .fetchAddresses(context);
    });
    super.initState();
  }

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
          Consumer<BusinessSetupController>(
            builder: (context, businussSetup, _) {
              return Positioned(
                top: MediaQuery.of(context).size.height * 0.10,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    businussSetup.businessSetup!.companyInfo.name,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'Pickup or Delivery',
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(
                            2,
                            (index) {
                              return OptionContainerWidget(
                                text: texts[index],
                                icon: index == 0
                                    ? 'assets/images/food_delivery.svg'
                                    : 'assets/images/Location.svg',
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                isSelected: index == selectedIndex,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          selectedIndex == 1
                              ? 'Select a branch:'
                              : 'Select an address',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        selectedIndex == 0
                            ? const DeliveryContent()
                            : const PickupContent(),
                        const SizedBox(height: 20),
                        Consumer<AddressProvider>(
                          builder: (context, ap, _) {
                            return ElevatedButton(
                              onPressed: () {
                                if (ap.selectedAddressId == null &&
                                    ap.selectedBranchId == null) {
                                  showTopSnackBar(
                                    context,
                                    'Please select an address or a branch',
                                    Icons.cancel,
                                    maincolor,
                                    const Duration(seconds: 2),
                                  );
                                } else {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) =>
                                          const TabsScreen(initialIndex: 0),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: maincolor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                minimumSize: const Size(double.infinity, 55),
                              ),
                              child: const Text(
                                'Done',
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
