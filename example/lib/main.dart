import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WebViewPage(),
    );
  }
}

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final InAppWebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nsmall WebView')),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri('https://m.nsmall.com')),
        onWebViewCreated: (controller) {
          _controller = controller;
          _controller.addJavaScriptHandler(
            handlerName: 'callbackHandler',
            callback: (args) {
              // Handle messages from the webpage here.
              debugPrint('Received message: $args');
              return 'Response from Flutter';
            },
          );
        },
        onLoadStop: (controller, url) async {
          await controller.evaluateJavascript(source: _wrapperScript);
        },
      ),
    );
  }

  static const String _wrapperScript = '''
  window.nshub = {
    callbackHandler: function() {
      return window.flutter_inappwebview.callHandler('callbackHandler', ...arguments);
    }
  };
  ''';
}
