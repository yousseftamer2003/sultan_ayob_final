import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/controllers/time_schedule_provider.dart';
import 'package:food2go_app/generated/l10n.dart';
import 'package:food2go_app/models/categories/product_model.dart';
import 'package:food2go_app/models/checkout/place_order_model.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';
import 'package:food2go_app/view/widgets/show_top_snackbar.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../../../controllers/address/get_address_provider.dart';
import '../../../controllers/checkout/image_provider.dart';
import '../../../controllers/checkout/place_order_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen(
      {super.key,
      required this.cartProducts,
      required this.totalTax,
      required this.totalDiscount});
  final List<Product> cartProducts;
  final double totalTax;
  final double totalDiscount;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? selectedPaymentMethod;
  int? selectedScheduleId;
  bool deliveryNow = true;
  double zonePrice = 0.0;
  bool isChosen = false;
  final TextEditingController noteController = TextEditingController();
  final TextEditingController deliveryTimeController = TextEditingController();
  bool isLoading = false;
  bool isScheduleExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderTypesAndPaymentsProvider>(context, listen: false)
          .fetchOrderTypesAndPayments(context);

      Provider.of<AddressProvider>(context, listen: false)
          .fetchAddresses(context);

      Provider.of<ScheduleProvider>(context, listen: false)
          .fetchScheduleList()
          .then((_) {
        // Set the default delivery now option when schedule list is loaded
        _setDefaultDeliveryNowOption();
      });
    });
  }

  void _setDefaultDeliveryNowOption() {
    final scheduleProvider =
        Provider.of<ScheduleProvider>(context, listen: false);
    if (scheduleProvider.scheduleList.isNotEmpty) {
      // Find the delivery now option in the schedule list
      final deliveryNowOption = scheduleProvider.scheduleList.firstWhere(
        (item) =>
            item.name.toLowerCase().contains('now') ||
            item.name.toLowerCase().contains('immediate'),
        orElse: () => scheduleProvider.scheduleList
            .first, // Fallback to first option if 'now' is not found
      );

      setState(() {
        selectedScheduleId = deliveryNowOption.id;
        deliveryNow = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderTypesAndPaymentsProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);
    final scheduleProvider = Provider.of<ScheduleProvider>(context);

    final paymentMethods = provider.data?.paymentMethods ?? [];

    return Scaffold(
      appBar: buildAppBar(context, S.of(context).checkout),
      body: provider.isLoading ||
              addressProvider.isLoading ||
              scheduleProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    _buildSectionTitle(S.of(context).payment_method),
                    const SizedBox(height: 10),
                    Column(
                      children: paymentMethods.map((method) {
                        return _buildPaymentMethodTile(method);
                      }).toList(),
                    ),
                    const SizedBox(height: 30),
                    _buildSectionTitle(
                        S.of(context).Please_select_a_delivery_time),
                    const SizedBox(height: 10),
                    _buildTimeScheduleButtons(scheduleProvider),
                    const SizedBox(height: 30),
                    _buildSectionTitle(S.of(context).note),
                    const SizedBox(height: 10),
                    _buildNoteInputField(),
                    const SizedBox(height: 30),
                    _buildPlaceOrderButton(context),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTimeScheduleButtons(ScheduleProvider scheduleProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            "delivery time: ${scheduleProvider.scheduleList.firstWhere((item) => item.id == selectedScheduleId).name}",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 12.0,
          children: scheduleProvider.scheduleList.map((scheduleItem) {
            final isSelected = selectedScheduleId == scheduleItem.id;
            final isDeliveryNowOption =
                scheduleItem.name.toLowerCase().contains('now') ||
                    scheduleItem.name.toLowerCase().contains('immediate');

            return InkWell(
              onTap: () {
                setState(() {
                  selectedScheduleId = scheduleItem.id;
                  deliveryNow = isDeliveryNowOption;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? maincolor : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: isSelected ? maincolor : Colors.grey[300]!,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  scheduleItem.name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (scheduleProvider.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              scheduleProvider.error!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceOrderButton(BuildContext context) {
    final imageServices = Provider.of<ImageServices>(context, listen: false);
    final addressProvider =
        Provider.of<AddressProvider>(context, listen: false);

    String formatTimeWithSeconds() {
      final now = DateTime.now();
      return '${now.hour.toString().padLeft(2, '0')}:'
          '${now.minute.toString().padLeft(2, '0')}:'
          '${now.second.toString().padLeft(2, '0')}';
    }

    return ElevatedButton(
      onPressed: () async {
        setState(() {
          isLoading = true;
        });

        final selectedAddressId = addressProvider.selectedAddressId;
        final selectedBranchId = addressProvider.selectedBranchId;

        String orderType = selectedBranchId != null ? 'take_away' : 'delivery';

        if (selectedPaymentMethod == null) {
          showTopSnackBar(
              context,
              S.of(context).Please_select_a_payment_method_and_delivery_option,
              Icons.warning_outlined,
              maincolor,
              const Duration(seconds: 4));
          setState(() {
            isLoading = false;
          });
          return;
        }

        if (selectedAddressId == null && selectedBranchId == null) {
          showTopSnackBar(
              context,
              'Please select a delivery address or pickup branch',
              Icons.warning_outlined,
              maincolor,
              const Duration(seconds: 4));
          setState(() {
            isLoading = false;
          });
          return;
        }

        if (selectedScheduleId == null) {
          showTopSnackBar(context, 'Please select a delivery time',
              Icons.warning_outlined, maincolor, const Duration(seconds: 4));
          setState(() {
            isLoading = false;
          });
          return;
        }

        try {
          final selectedPayment =
              Provider.of<OrderTypesAndPaymentsProvider>(context, listen: false)
                  .data
                  ?.paymentMethods
                  .firstWhere((method) => method.name == selectedPaymentMethod);

          if (selectedPayment == null) {
            showTopSnackBar(context, S.of(context).try_another_payment_please,
                Icons.warning_outlined, maincolor, const Duration(seconds: 4));
            setState(() {
              isLoading = false;
            });
            return;
          }

          final receiptBase64 = imageServices.image != null
              ? imageServices.convertImageToBase64(imageServices.image!)
              : '';

          String deliveryTime = formatTimeWithSeconds();

          await Provider.of<ProductProvider>(context, listen: false).postCart(
            context,
            products: widget.cartProducts,
            date: deliveryTime,
            branchId: selectedBranchId,
            totalTax: widget.totalTax,
            addressId: selectedAddressId,
            orderType: orderType,
            paymentMethodId: selectedPayment.id,
            receipt: receiptBase64,
            notes: noteController.text,
            zonePrice: zonePrice,
            totalDiscount: widget.totalDiscount,
            secheduleslotid: selectedScheduleId,
          );
          setState(() {
            isLoading = false;
          });
        } catch (e) {
          log('message error in place order: $e');
          setState(() {
            isLoading = false;
          });
          showTopSnackBar(context, 'An error occurred while placing your order',
              Icons.error, Colors.red, const Duration(seconds: 4));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: maincolor,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                S.of(context).place_order,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: maincolor,
      ),
    );
  }

  Widget _buildPaymentMethodTile(PaymentMethod method) {
    final imageServices = Provider.of<ImageServices>(context);
    return Column(
      children: [
        RadioListTile<String>(
          value: method.name,
          groupValue: selectedPaymentMethod,
          onChanged: (String? value) {
            setState(() {
              selectedPaymentMethod = value;
            });
          },
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  method.logo!,
                  width: 45,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                method.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          activeColor: maincolor,
        ),
        if (selectedPaymentMethod != null &&
            selectedPaymentMethod != 'cash' &&
            selectedPaymentMethod != 'Visa Master Card' &&
            selectedPaymentMethod == method.name)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${S.of(context).PayTo} ',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  S.of(context).upload_reciept,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    await imageServices.pickImage();
                  },
                  icon: const Icon(Icons.upload_file),
                  label: Text(S.of(context).upload_reciept),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: maincolor,
                    foregroundColor: Colors.white,
                  ),
                ),
                if (imageServices.image != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(S.of(context).receipt_uploaded_successfully),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildNoteInputField() {
    return TextField(
      controller: noteController,
      decoration: InputDecoration(
        hintText: S.of(context).add_note,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
