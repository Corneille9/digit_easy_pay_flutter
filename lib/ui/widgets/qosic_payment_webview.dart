import 'package:digit_easy_pay_flutter/src/common/payment_theme.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class QosicPaymentWebView extends StatefulWidget {
  const QosicPaymentWebView({super.key, required this.url, required this.theme});
  final String url;
  final PaymentTheme theme;

  @override
  State<QosicPaymentWebView> createState() => _FedapayPaymentWebViewState();
}

class _FedapayPaymentWebViewState extends State<QosicPaymentWebView> {
  PaymentTheme get theme => widget.theme;
  String get url => widget.url;
  late WebViewController controller;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      // ..setBackgroundColor(theme.backgroundColor)
      ..setNavigationDelegate(
        NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                debugPrint(request.url);
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            onUrlChange: (UrlChange url) async {
              // if(!url.url.toString().startsWith("https://digit.pay.sdk.com/callback/fedapay")){
              //   return;
              // }
              // var r = await provider.checkStatus();
              // Future(() => Navigator.pop(context),);
            }
        ),
      )
      ..loadRequest(Uri.parse(url));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller,);
  }
}
