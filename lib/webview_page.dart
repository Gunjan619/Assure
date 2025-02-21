import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store'),
        backgroundColor: Color(0xFFF67E7D), // Coral Pink App Bar
      ),
      body: WebView(
        initialUrl: 'https://firststep.pythonanywhere.com',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
