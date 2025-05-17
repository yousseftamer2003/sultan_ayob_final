import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/models/orders/order_history_model.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';

class SingleOrderHistoryScreen extends StatelessWidget {
  final OrderHistoryModel order;

  const SingleOrderHistoryScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: buildAppBar(context, 'Order #${order.orderNumber ?? order.id}'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getOrderStatusText(),
                style: const TextStyle(
                    color: maincolor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (order.orderStatus?.toLowerCase() == 'canceled') ...[
                buildSectionTitle('Cancellation Reason'),
                const SizedBox(height: 16),
                buildCancellationInfo(),
                const SizedBox(height: 16),
              ],
              if (order.orderType == 'delivery') ...[
                buildSectionTitle('Delivery Info'),
                buildDeliveryInfo(),
                const SizedBox(height: 16),
              ],
              buildSectionTitle('Item Info'),
              buildItemInfo(),
              const SizedBox(height: 16),
              if (order.captainId != null) ...[
                buildSectionTitle('Delivery Man'),
                buildDeliveryManInfo(),
                const SizedBox(height: 16),
              ],
              buildSectionTitle('Payment Info'),
              buildPaymentInfo(),
              const SizedBox(height: 16),
              if (order.notes != null && order.notes!.isNotEmpty) ...[
                buildSectionTitle('Order Notes'),
                buildOrderNotes(),
                const SizedBox(height: 16),
              ],
              buildPriceDetails(),
            ],
          ),
        ),
      ),
    );
  }

  String _getOrderStatusText() {
    switch (order.orderStatus?.toLowerCase()) {
      case 'delivered':
        return 'Your Order Is Delivered';
      case 'canceled':
        return 'Your Order Was Canceled';
      case 'pending':
        return 'Your Order Is Pending';
      case 'processing':
        return 'Your Order Is Being Processed';
      case 'shipping':
      case 'shipped':
        return 'Your Order Is On The Way';
      default:
        return 'Order Status: ${order.orderStatus ?? "Unknown"}';
    }
  }

  Widget buildCancellationInfo() {
    String? cancellationReason = order.rejectedReason ??
        order.adminCancelReason ??
        order.customerCancelReason;

    String reasonSource = '';
    IconData icon = Icons.info;
    Color iconColor = maincolor;

    if (order.rejectedReason != null && order.rejectedReason!.isNotEmpty) {
      reasonSource = 'Rejected';
      icon = Icons.cancel;
      iconColor = maincolor;
    } else if (order.adminCancelReason != null &&
        order.adminCancelReason!.isNotEmpty) {
      reasonSource = 'Canceled by Admin';
      icon = Icons.admin_panel_settings;
      iconColor = maincolor;
    } else if (order.customerCancelReason != null &&
        order.customerCancelReason!.isNotEmpty) {
      reasonSource = 'Canceled by Customer';
      icon = Icons.person_off;
      iconColor = maincolor;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reasonSource.isNotEmpty
                      ? '$reasonSource:'
                      : 'Reason for cancellation:',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  cancellationReason ?? 'No reason provided',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget buildDeliveryInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'From',
            style: TextStyle(color: Colors.grey),
          ),
          Text('Branch #${order.branchId ?? "Unknown"}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'To',
            style: TextStyle(color: Colors.grey),
          ),
          Text('Address #${order.addressId ?? "Unknown"}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget buildItemInfo() {
    if (order.orderDetails == null || order.orderDetails!.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text('No items found'),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: order.orderDetails!.length,
        itemBuilder: (context, index) {
          final orderDetail = order.orderDetails![index];

          if (orderDetail.product == null || orderDetail.product!.isEmpty) {
            return const SizedBox();
          }

          return Column(
            children:
                List.generate(orderDetail.product!.length, (productIndex) {
              final productWrapper = orderDetail.product![productIndex];
              final product = productWrapper.product;
              final count = productWrapper.count ?? 1;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.fastfood),
                    title: Text(product?.name ?? 'Unknown Product',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        '${product?.price?.toStringAsFixed(2) ?? "0.00"} £'),
                    trailing: Text('X $count'),
                  ),

                  // Show addons if available
                  if (product?.addons != null && product!.addons!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: product.addons!.map((addon) {
                          return Text(
                            'Adds On: ${addon.name} ${addon.price?.toStringAsFixed(2) ?? "0.00"} £',
                            style: const TextStyle(color: Colors.grey),
                          );
                        }).toList(),
                      ),
                    ),

                  // Show notes if available
                  if (productWrapper.notes != null &&
                      productWrapper.notes!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Notes: ${productWrapper.notes}',
                        style: const TextStyle(
                            color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                    ),

                  const Divider(),
                ],
              );
            }),
          );
        },
      ),
    );
  }

  Widget buildDeliveryManInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          CircleAvatar(
              backgroundImage: AssetImage('assets/images/delivery.png')),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Delivery Man',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Text('4.0 ', style: TextStyle(color: Colors.orange)),
                  Icon(Icons.star, color: Colors.orange, size: 16),
                ],
              ),
            ],
          ),
          Spacer(),
          Icon(Icons.message, color: Colors.grey),
          SizedBox(width: 8),
          Icon(Icons.phone, color: Colors.grey),
        ],
      ),
    );
  }

  Widget buildPaymentInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.payment, color: maincolor),
          const SizedBox(width: 16),
          Text(order.paymentMethod?.name ?? 'Unknown Payment Method',
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget buildOrderNotes() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(order.notes ?? ''),
    );
  }

  Widget buildPriceDetails() {
    double itemsPrice = 0.0;
    double addonsPrice = 0.0;

    if (order.orderDetails != null) {
      for (var orderDetail in order.orderDetails!) {
        if (orderDetail.product != null) {
          for (var productWrapper in orderDetail.product!) {
            if (productWrapper.product != null) {
              itemsPrice += (productWrapper.product!.price ?? 0) *
                  (productWrapper.count ?? 1);

              if (productWrapper.product!.addons != null) {
                for (var addon in productWrapper.product!.addons!) {
                  addonsPrice += addon.price ?? 0;
                }
              }
            }
          }
        }
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          buildPriceRow('Items Price', '${itemsPrice.toStringAsFixed(2)} £'),
          if (addonsPrice > 0)
            buildPriceRow('Addons', '+ ${addonsPrice.toStringAsFixed(2)} £'),
          buildPriceRow('Discount',
              '- ${order.totalDiscount?.toStringAsFixed(2) ?? "0.00"} £'),
          buildPriceRow(
              'Vat/Tax', '+ ${order.totalTax?.toStringAsFixed(2) ?? "0.00"} £'),
          buildPriceRow('Coupon Discount',
              '- ${order.couponDiscount?.toString() ?? "0.00"} £'),
          buildPriceRow('Delivery Fee', '+ 0.00 £'), 
          const Divider(),
          buildPriceRow(
              'Total Amount', '${order.amount?.toStringAsFixed(2) ?? "0.00"} £',
              isTotal: true),
        ],
      ),
    );
  }

  Widget buildPriceRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(
            amount,
            style: TextStyle(
              color: isTotal ? maincolor : Colors.black,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
