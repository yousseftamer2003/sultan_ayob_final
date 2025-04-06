import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/view/screens/tabs_screen.dart';

class OrderFailedScreen extends StatelessWidget {
  const OrderFailedScreen({super.key, required this.orderId});
  final int orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 180,),
                const Icon(Icons.cancel_outlined,size: 200,color: maincolor,),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Order Failed',
                  style: TextStyle(fontSize: 24),
                ),
                Text('Order Number: #$orderId')
              ],
            ),
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width/1.1,
                  height:MediaQuery.sizeOf(context).height/14,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: maincolor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Back to Check out',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx)=> const TabsScreen(initialIndex: 0))
                      );
                    },
                    child: const Text(
                      'Back to home',
                      style: TextStyle(
                          color: maincolor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    )),
                const SizedBox(height: 50,)
              ],
            )
          ],
        ),
      ),
    );
  }
}
