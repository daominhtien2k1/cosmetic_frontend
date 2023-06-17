import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TestBaumannScreen extends StatefulWidget {
  const TestBaumannScreen({super.key});

  @override
  State<TestBaumannScreen> createState() => _TestBaumannScreenState();
}

class _TestBaumannScreenState extends State<TestBaumannScreen> {
  late final WebViewController controller;


  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse("https://mochuongvietnam.vn/trac-nghiem-phan-loai-da-chi-tiet")
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(
          controller: controller,
        )
      ),
    );
  }
}
