import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/address/get_address_provider.dart';
import 'package:food2go_app/view/screens/tabs_screens/screens/profile_screen/add_address_screen.dart';
import 'package:provider/provider.dart';

class DeliveryContent extends StatefulWidget {
  const DeliveryContent({super.key});

  @override
  State<DeliveryContent> createState() => _DeliveryContentState();
}

class _DeliveryContentState extends State<DeliveryContent> {
  int? selectedAddress;
  @override
  Widget build(BuildContext context) {
    return Consumer<AddressProvider>(
      builder: (context, addressProvider, _) {
        if (addressProvider.isLoading) {
          return const Center(
              child: CircularProgressIndicator(
            color: maincolor,
          ));
        } else {
          return Column(children: [
            ...List.generate(
              addressProvider.addresses.length,
              (index) {
                final address = addressProvider.addresses[index];
                return _buildAddressCard(address.zone.zone, address.address,
                    index == selectedAddress, onTap: () {
                  setState(() {
                    if (selectedAddress == index) {
                      selectedAddress = null;
                      addressProvider.selectedAddressId = null;
                    } else {
                      selectedAddress = index;
                      addressProvider.selectedAddressId = address.id;
                    }
                  });
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AddAddressScreen(),
                      ));
                    },
                    child: const Text(
                      '+ Add new Address',
                      style: TextStyle(color: maincolor),
                    )),
              ],
            ),
          ]);
        }
      },
    );
  }
}

Widget _buildAddressCard(String title, String subTitle, bool isSelected,
    {Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Card(
      color: isSelected ? maincolor : Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.only(right: 16),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: maincolor,
              ),
              child: const Icon(Icons.restaurant_menu,
                  color: Colors.white, size: 35),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.black.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
