import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/view/screens/checkout/order_completed_screen.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  final String url;
  final int orderId;

  const PaymentWebView({super.key, required this.url, required this.orderId});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Optional: Add a loading indicator here
          },
          onPageStarted: (String url) {
            log('Page started loading: $url');
          },
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {
            log('HTTP error: $error');
          },
          onWebResourceError: (WebResourceError error) {
            log('Web resource error: $error');
          },
          onNavigationRequest: (NavigationRequest request) {
            log('call back Url: ${request.url}');
            if (request.url.startsWith(
                'https://sultanayubbcknd.food2go.online/customer/make_order/')) {
              if (request.url.contains('success=true')) {
                _handlePaymentSuccess();
              } else {
                Navigator.of(context).pop(true);
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _handlePaymentSuccess() {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productProvider.clearCart();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => OrderCompletedScreen(orderId: widget.orderId)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paymob Payment'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
