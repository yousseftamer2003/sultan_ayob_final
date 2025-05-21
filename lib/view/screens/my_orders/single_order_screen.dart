import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/models/orders/orders_model.dart';
import 'package:intl/intl.dart';

class SingleOrderScreen extends StatelessWidget {
  final Order order;

  const SingleOrderScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          height: 32,
          width: 32,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: maincolor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'Order #${order.orderNumber ?? order.id}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderStatusCard(),
            const SizedBox(height: 20),
            _buildOrderItemsSection(context),
            const SizedBox(height: 20),
            _buildOrderDetailsSection(context),
            const SizedBox(height: 20),
            _buildPaymentDetailsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Order Status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusBackgroundColor(order.orderStatus),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.orderStatus ?? 'Unknown',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Order Date: ${_formatDateTime(order.orderDate, order.date)}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(String? date, String? time) {
    if (date == null || time == null || date.isEmpty || time.isEmpty) {
      return 'N/A';
    }

    try {
      final combined = DateTime.parse('$date $time');
      return DateFormat('MMM dd, yyyy - hh:mm a').format(combined);
    } catch (e) {
      return '$date $time';
    }
  }

  Widget _buildOrderItemsSection(BuildContext context) {
    final orderDetails = order.orderDetails ?? [];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            orderDetails.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'No items found',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: orderDetails.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final orderDetail = orderDetails[index];

                      final productItems =
                          orderDetail.product?.map((productWrapper) {
                                final product = productWrapper.product;
                                final count = productWrapper.count ?? 1;
                                final notes = productWrapper.notes;

                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    '${product?.name ?? 'Unknown Product'} x$count',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (notes != null && notes.isNotEmpty)
                                        Text('Note: $notes'),
                                      Text(
                                        '${product?.price?.toStringAsFixed(2) ?? '0.00'} £',
                                        style: const TextStyle(
                                          color: maincolor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Text(
                                    '${(product?.price ?? 0 * count).toStringAsFixed(2)} £',
                                  ),
                                );
                              }).toList() ??
                              [];

                      // Process addons
                      final addonItems =
                          orderDetail.addons?.map((addonWrapper) {
                                final addon = addonWrapper.addon;
                                final count = addonWrapper.count ?? 1;

                                return ListTile(
                                  contentPadding:
                                      const EdgeInsets.only(left: 16, right: 0),
                                  title: Text(
                                    '+ ${addon?.name ?? 'Unknown Addon'} x$count',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  trailing: Text(
                                    '${(addon?.price ?? 0 * count).toStringAsFixed(2)} £',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList() ??
                              [];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...productItems,
                          ...addonItems,
                        ],
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailsSection(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Order Type', order.orderType ?? 'N/A'),
            if (order.orderType == 'take_away')
              _buildDetailRow('Branch Name', order.branchName ?? 'N/A'),
            if (order.orderType == 'delivery')
              _buildDetailRow('Address Name', order.addressName ?? 'N/A'),
            if (order.notes != null && order.notes!.isNotEmpty)
              _buildDetailRow('Notes', order.notes!),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetailsSection(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
                'Payment Method', order.paymentMethod?.name ?? 'N/A'),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            if (order.deliveryPrice != null)
              _buildPriceRow('Delivery', order.deliveryPrice!),
            if (order.totalTax != null && order.totalTax! > 0)
              _buildPriceRow('Tax', order.totalTax!),
            if (order.totalDiscount != null && order.totalDiscount! > 0)
              _buildPriceRow('Discount', -order.totalDiscount!),
            if (order.couponDiscount != null && order.couponDiscount! > 0)
              _buildPriceRow('Coupon Discount', -order.couponDiscount!),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${order.amount?.toStringAsFixed(2) ?? '0.00'} £',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: maincolor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 35,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 65,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          Text(
            '${amount.toStringAsFixed(2)} £',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusBackgroundColor(String? status) {
    if (status == null) return Colors.grey;

    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipping':
      case 'shipped':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
