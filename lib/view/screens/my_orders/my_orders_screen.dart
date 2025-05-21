import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/orders/orders_history_provider.dart';
import 'package:food2go_app/controllers/orders/orders_provider.dart';
import 'package:food2go_app/generated/l10n.dart';
import 'package:food2go_app/models/orders/order_history_model.dart';
import 'package:food2go_app/models/orders/orders_model.dart';
import 'package:food2go_app/view/screens/my_orders/single_order_history_screen.dart';
import 'package:food2go_app/view/screens/my_orders/single_order_screen.dart';
import 'package:food2go_app/view/screens/order_tracing_screen.dart';
import 'package:food2go_app/view/screens/tabs_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrdersProvider>(context, listen: false).fetchOrders(context);
      Provider.of<OrdersHistoryProvider>(context, listen: false)
          .fetchOrdershistory(context);
    });
  }

  Future<void> _refreshOrders() async {
    await Provider.of<OrdersProvider>(context, listen: false)
        .fetchOrders(context);
    await Provider.of<OrdersHistoryProvider>(context, listen: false)
        .fetchOrdershistory(context);
    return Future.value();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: _refreshOrders,
        color: maincolor,
        child: Consumer2<OrdersProvider, OrdersHistoryProvider>(
          builder: (context, ordersProvider, ordersHistoryProvider, _) {
            // Since isLoading isn't available, we'll work with the data directly
            final ongoingOrders = ordersProvider.orderresponse?.orders ?? [];
            final historyOrders =
                ordersHistoryProvider.ordersHistory?.orders ?? [];

            return TabBarView(
              controller: _tabController,
              children: [
                ongoingOrders.isEmpty
                    ? _buildEmptyState(context, isOngoing: true)
                    : _buildOrderList(context, ongoingOrders),
                historyOrders.isEmpty
                    ? _buildEmptyState(context, isOngoing: false)
                    : _buildHistoryOrderList(context, historyOrders),
              ],
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Container(
        height: 36,
        width: 36,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new, size: 18, color: maincolor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: Text(
        S.of(context).myOrder,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: maincolor,
        indicatorWeight: 3,
        labelColor: maincolor,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        tabs: [
          Tab(text: S.of(context).ongoing),
          Tab(text: S.of(context).history),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, {required bool isOngoing}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                isOngoing ? Icons.shopping_bag_outlined : Icons.history,
                size: 60,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isOngoing ? S.of(context).ongoing : S.of(context).noOrderHistory,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isOngoing
                  ? "You don't have any active orders at the moment"
                  : "You haven't made any purchase yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: maincolor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TabsScreen(initialIndex: 0),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.restaurant_menu, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    S.of(context).exploreMenu,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, List<Order> orders) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(context, orders[index]);
      },
    );
  }

  Widget _buildHistoryOrderList(
      BuildContext context, List<OrderHistoryModel> orders) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildOrderHistoryCard(context, orders[index]);
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);

    DateTime? cancelTimeDate;
    if (ordersProvider.cancelTime != null) {
      cancelTimeDate =
          DateFormat("yyyy-MM-dd HH:mm:ss").parse(ordersProvider.cancelTime!);
    }

    final canCancelOrder =
        cancelTimeDate != null && DateTime.now().isBefore(cancelTimeDate);
    final statusColor = _getStatusColor(order.orderStatus);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () => _showOrderOptions(context, order, canCancelOrder),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  _buildOrderStatusIndicator(statusColor),
                  const SizedBox(width: 8),
                  Text(
                    order.orderStatus ?? 'Unknown',
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    order.date ?? '',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/medium.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.orderNumber ?? order.id}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          order.paymentMethod?.name ?? 'Unknown payment',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.monetization_on,
                                size: 16, color: maincolor),
                            const SizedBox(width: 4),
                            Text(
                              '${order.amount?.toStringAsFixed(2) ?? '0.00'} £',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: maincolor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderHistoryCard(BuildContext context, OrderHistoryModel order) {
    final statusColor = _getStatusColor(order.orderStatus);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingleOrderHistoryScreen(order: order),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  _buildOrderStatusIndicator(statusColor),
                  const SizedBox(width: 8),
                  Text(
                    order.orderStatus ?? 'Unknown',
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    order.date ?? '',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/medium.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.orderNumber ?? order.id}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          order.paymentMethod?.name ?? 'Unknown payment',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.monetization_on,
                                size: 16, color: maincolor),
                            const SizedBox(width: 4),
                            Text(
                              '${order.amount?.toStringAsFixed(2) ?? '0.00'} £',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: maincolor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderStatusIndicator(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  void _showOrderOptions(
      BuildContext context, Order order, bool canCancelOrder) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        S.of(context).order_actions,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                _buildActionItem(
                  context,
                  icon: Icons.location_on,
                  title: S.of(context).track_order,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderTrackingScreen(orderId: order.id),
                      ),
                    );
                  },
                ),
                _buildActionItem(
                  context,
                  icon: Icons.info_outline,
                  title: "View Details",
                  color: maincolor,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SingleOrderScreen(order: order),
                      ),
                    );
                  },
                ),
                if (canCancelOrder)
                  _buildActionItem(
                    context,
                    icon: Icons.cancel_outlined,
                    title: S.of(context).cancel_order,
                    color: Colors.red,
                    onTap: () async {
                      Navigator.pop(context);
                      await Provider.of<OrdersProvider>(context, listen: false)
                          .cancelOrder(context, order.id!);
                    },
                  )
                else
                  _buildActionItem(
                    context,
                    icon: Icons.timer_off,
                    title: S.of(context).cancellation_time_expired,
                    color: Colors.grey,
                    onTap: null,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required Function()? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: onTap == null ? Colors.grey : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  Color _getStatusColor(String? status) {
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
      case 'confirmed':
        return Colors.green;
      case 'out_for_delivery':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
