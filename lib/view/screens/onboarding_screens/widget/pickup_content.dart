import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/address/get_address_provider.dart';
import 'package:provider/provider.dart';

class PickupContent extends StatefulWidget {
  const PickupContent({super.key});

  @override
  State<PickupContent> createState() => _PickupContentState();
}

class _PickupContentState extends State<PickupContent> {
  int? selectedBranch;
  @override
  Widget build(BuildContext context) {
    return Consumer<AddressProvider>(
      builder: (context, branchProvider, _) {
        if (branchProvider.isLoading) {
          return const Center(
              child: CircularProgressIndicator(
            color: maincolor,
          ));
        } else {
          return Column(
              children: List.generate(
            branchProvider.branchStarters.length,
            (index) {
              final branch = branchProvider.branchStarters[index];
              return _buildBranchCard(
                  branch.name, branch.address, index == selectedBranch,
                  onTap: () {
                setState(() {
                  if (selectedBranch == index) {
                    selectedBranch = null;
                  } else {
                    selectedBranch = index;
                    branchProvider.selectedBranchId = branch.id;
                  }
                });
              });
            },
          ));
        }
      },
    );
  }
}

Widget _buildBranchCard(String title, String subTitle, bool isSelected,
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
                    style: TextStyle(fontWeight: FontWeight.bold,color: isSelected ? Colors.white : Colors.black),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: isSelected ? Colors.white : Colors.black.withOpacity(0.7)),
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
