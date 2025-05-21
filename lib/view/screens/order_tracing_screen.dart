// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/generated/l10n.dart';
import 'package:food2go_app/view/screens/tabs_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderTrackingScreen extends StatelessWidget {
  final int? orderId;
  final int? deliveryManId;

  const OrderTrackingScreen({
    Key? key,
    required this.orderId,
    this.deliveryManId,
  }) : super(key: key);

  Future<Map<String, dynamic>> fetchOrderDetails(BuildContext context) async {
    try {
      final url = Uri.parse(
          'https://sultanayubbcknd.food2go.online/customer/orders/order_status/$orderId');
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final String token = loginProvider.token ?? '';

      if (token.isEmpty) {
        throw Exception('No authentication token found');
      }

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }).timeout(const Duration(seconds: 15)); // Add timeout

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        log("Order ID: $orderId, Delivery ID: ${data['delivery_id']}");
        return data;
      } else {
        throw Exception(
            'Failed to load order details. Status: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching order details: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const TabsScreen(initialIndex: 0),
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          title: Text(
            S.of(context).order_tracking,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const TabsScreen(initialIndex: 0),
                ),
              );
            },
            child: Container(
              height: 32,
              width: 32,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: maincolor,
                ),
              ),
            ),
          ),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: fetchOrderDetails(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(maincolor),
                ),
              );
            } else if (snapshot.hasError) {
              return ErrorDisplay(error: snapshot.error.toString());
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text(
                  'No order data found',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              );
            } else {
              final data = snapshot.data!;
              final status = data['status'] ?? 'unknown';
              final orderNumber = data['order_id'] ?? orderId;
              final restaurant = data['restaurant_name'] ?? 'Restaurant';

              return OrderTrackingContent(
                status: status,
                orderNumber: orderNumber,
                restaurant: restaurant,
              );
            }
          },
        ),
      ),
    );
  }
}

class ErrorDisplay extends StatelessWidget {
  final String error;

  const ErrorDisplay({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'Failed to load order details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Go Back'),
            style: ElevatedButton.styleFrom(
              backgroundColor: maincolor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderTrackingContent extends StatelessWidget {
  final String status;
  final dynamic orderNumber;
  final String restaurant;

  const OrderTrackingContent({
    super.key,
    required this.status,
    required this.orderNumber,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: OrderInfoCard(
            orderNumber: orderNumber,
            restaurant: restaurant,
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Text(
              'Order Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildOrderStatusItem(
                context: context,
                icon: Icons.receipt_rounded,
                title: S.of(context).pending,
                subtitle: 'Order received',
                isActive: true, // Always active since the order exists
                isLast: false,
              ),
              _buildOrderStatusItem(
                context: context,
                icon: Icons.verified_user_rounded,
                title: S.of(context).preparing,
                subtitle: 'Restaurant confirmed your order',
                isActive: status == 'confirmed' ||
                    status == 'processing' ||
                    status == 'out_for_delivery' ||
                    status == 'scheduled' ||
                    status == 'delivered',
                isLast: false,
              ),
              _buildOrderStatusItem(
                context: context,
                icon: Icons.restaurant_rounded,
                title: 'Processing',
                subtitle: 'Your food is being prepared',
                isActive: status == 'processing' ||
                    status == 'out_for_delivery' ||
                    status == 'scheduled' ||
                    status == 'delivered',
                isLast: false,
              ),
              _buildOrderStatusItem(
                context: context,
                icon: Icons.delivery_dining_rounded,
                title: S.of(context).out_for_delivery,
                subtitle: 'Your food is on the way',
                isActive: status == 'out_for_delivery' || status == 'delivered',
                isLast: false,
              ),
              _buildOrderStatusItem(
                context: context,
                icon: Icons.check_circle_rounded,
                title: S.of(context).delivered,
                subtitle: 'Enjoy your meal!',
                isActive: status == 'delivered',
                isLast: true,
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderStatusItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isActive,
    required bool isLast,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isActive ? maincolor : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: isActive
                          ? maincolor.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: isActive
                      ? null
                      : Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: isActive ? Colors.white : Colors.grey.shade400,
                ),
              ),
              if (!isLast)
                CustomDashedLine(
                  isActive: isActive,
                  height: 50,
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isActive ? maincolor : Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isActive ? Colors.black54 : Colors.grey.shade400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderInfoCard extends StatelessWidget {
  final dynamic orderNumber;
  final String restaurant;

  const OrderInfoCard({
    super.key,
    required this.orderNumber,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 50,
                  height: 50,
                  color: maincolor.withOpacity(0.1),
                  child: const Icon(
                    Icons.restaurant_rounded,
                    color: maincolor,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Order #$orderNumber',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  context: context,
                  icon: Icons.calendar_today_rounded,
                  title: DateFormat('MMM d').format(DateTime.now()),
                  subtitle: 'Order date',
                  isActive: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isActive,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isActive ? maincolor.withOpacity(0.1) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isActive ? maincolor : Colors.grey.shade500,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isActive ? maincolor : Colors.black87,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomDashedLine extends StatelessWidget {
  final bool isActive;
  final double height;

  const CustomDashedLine({
    Key? key,
    required this.isActive,
    this.height = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: 2,
      child: CustomPaint(
        painter: DashedLinePainter(
          isActive ? maincolor : Colors.grey.shade300,
        ),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    double dashWidth = 3, dashSpace = 3;
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
