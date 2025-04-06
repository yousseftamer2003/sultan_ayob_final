// ignore_for_file: use_build_context_synchronously, avoid_print
import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/orders/orders_history_provider.dart';
import 'package:food2go_app/controllers/orders/orders_provider.dart';
import 'package:food2go_app/generated/l10n.dart';
import 'package:food2go_app/models/orders/order_history_model.dart';
import 'package:food2go_app/models/orders/orders_model.dart';
import 'package:food2go_app/view/screens/order_tracing_screen.dart';
import 'package:food2go_app/view/screens/tabs_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyOrderScreen extends StatelessWidget {
  const MyOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrdersProvider>(context, listen: false).fetchOrders(context);
      Provider.of<OrdersHistoryProvider>(context, listen: false)
          .fetchOrdershistory(context);
    });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
            S.of(context).myOrder,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: maincolor,
            labelColor: maincolor,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                child: Text(
                  S.of(context).ongoing,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  S.of(context).history,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Consumer2<OrdersProvider, OrdersHistoryProvider>(
          builder: (context, ordersProvider, ordersHistoryProvider, _) {
            final ongoingOrders = ordersProvider.orderresponse?.orders ?? [];
            final historyOrders =
                ordersHistoryProvider.ordersHistory?.orders ?? [];

            return TabBarView(
              children: [
                ongoingOrders.isEmpty
                    ? _buildNoOrderHistory(context)
                    : _buildOrderList(context, ongoingOrders),
                historyOrders.isEmpty
                    ? _buildNoOrderHistory(context)
                    : _buildHistoryOrderList(context, historyOrders),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNoOrderHistory(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fastfood,
              size: 100,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 20),
            Text(
              S.of(context).noOrderHistory,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "You haven't made any purchase yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: maincolor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TabsScreen(
                              initialIndex: 0,
                            )));
              },
              child: Text(
                S.of(context).exploreMenu,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
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

    // Convert cancelTime to DateTime format if it's in string format
    DateTime? cancelTimeDate;
    if (ordersProvider.cancelTime != null) {
      cancelTimeDate = DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(ordersProvider.cancelTime!); // Update format as per your API
    }

    // Check if the current time is before cancelTimeDate
    final canCancelOrder =
        cancelTimeDate != null && DateTime.now().isBefore(cancelTimeDate);

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(S.of(context).order_actions),
              content: Text(S.of(context).choose_action),
              actions: [
                TextButton(
                  onPressed: () {
                    // Navigate to OrderTrackingScreen or execute track order logic
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderTrackingScreen(orderId: order.id),
                      ),
                    );
                  },
                  child: Text(S.of(context).track_order),
                ),
                if (canCancelOrder)
                  TextButton(
                    onPressed: () async {
                      await ordersProvider.cancelOrder(context, order.id!);
                    },
                    child: Text(
                      S.of(context).cancel_order,
                      style: const TextStyle(color: maincolor),
                    ),
                  )
                else
                  TextButton(
                    onPressed: null, // Disable the button
                    child: Text(
                      S.of(context).cancellation_time_expired,
                      style: const TextStyle(
                          color: Colors.grey), // Greyed-out text to indicate it's disabled
                    ),
                  ),
              ],
            );
          },
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: maincolor,
                  borderRadius: BorderRadius.circular(12),
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
                      order.date ?? '',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Order #${order.id}',
                      style: const TextStyle(
                        color: maincolor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.amount ?? 0} £',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.paidBy ?? '',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                order.orderStatus ?? '',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderHistoryCard(BuildContext context, OrderHistoryModel order) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: maincolor,
                borderRadius: BorderRadius.circular(12),
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
                    order.date ?? '',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Order #${order.id}',
                    style: const TextStyle(
                      color: maincolor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${order.amount ?? 0} £',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.paidBy ?? '',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              order.orderStatus ?? '',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
