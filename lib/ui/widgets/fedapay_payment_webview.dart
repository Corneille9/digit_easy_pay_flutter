import 'package:digit_easy_pay_flutter/src/common/payment_theme.dart';
import 'package:digit_easy_pay_flutter/src/providers/fedapay_provider.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FedapayPaymentWebView extends StatefulWidget {
  const FedapayPaymentWebView({super.key, required this.provider, required this.theme});
  final FedapayPaymentProvider provider;
  final PaymentTheme theme;

  @override
  State<FedapayPaymentWebView> createState() => _FedapayPaymentWebViewState();
}

class _FedapayPaymentWebViewState extends State<FedapayPaymentWebView> {
  PaymentTheme get theme => widget.theme;
  FedapayPaymentProvider get provider => widget.provider;
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
              if(!mounted)return;

              if(!url.url.toString().startsWith("https://digit.pay.sdk.com/callback/fedapay")){
                return;
              }
              var r = await provider.checkStatus();
              Future(() => Navigator.pop(context),);
            }
        ),
      )
      ..loadRequest(Uri.parse(provider.transactionUrl!));
    super.initState();
  }

  @override
  void dispose() {
    controller.loadRequest(Uri.parse('about:blank'));
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller,);
  }
}
