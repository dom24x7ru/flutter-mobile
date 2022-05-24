import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UrlMiniApp extends StatefulWidget {
  final CookieManager? cookieManager;
  final String url;
  const UrlMiniApp({Key? key, required this.url, this.cookieManager}) : super(key: key);

  @override
  State<UrlMiniApp> createState() => _UrlMiniAppState();
}

class _UrlMiniAppState extends State<UrlMiniApp> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: widget.url,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      }
    );
  }
}
