library;

import 'package:digit_easy_pay_flutter/digit_easy_pay_flutter.dart';
import 'package:digit_easy_pay_flutter/src/ui/widgets/custom_widgets.dart';
import 'package:digit_easy_pay_flutter/src/ui/widgets/theme_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'paypal_service.dart';

class PaypalCheckoutView extends StatefulWidget {
  final Function onSuccess, onCancel, onError;
  final String? note, clientId, secretKey;

  final Widget? loadingIndicator;
  final List? transactions;
  final bool? sandboxMode;

  final PaymentConfig paymentConfig;

  const PaypalCheckoutView({
    super.key,
    required this.onSuccess,
    required this.onError,
    required this.onCancel,
    required this.transactions,
    required this.clientId,
    required this.secretKey,
    required this.paymentConfig,
    this.sandboxMode = false,
    this.note = '',
    this.loadingIndicator,
  });

  @override
  State<StatefulWidget> createState() {
    return PaypalCheckoutViewState();
  }
}

class PaypalCheckoutViewState extends State<PaypalCheckoutView> {
  String? checkoutUrl;
  String navUrl = '';
  String executeUrl = '';
  String accessToken = '';
  bool loading = true;
  bool pageloading = true;
  bool loadingError = false;
  late PaypalServices services;
  int pressed = 0;
  double progress = 0;
  final String returnURL = 'https://www.youtube.com/channel/UC9a1yj1xV2zeyiFPZ1gGYGw';
  final String cancelURL = 'https://www.facebook.com/tharwat.samy.9';

  late InAppWebViewController webView;

  PaymentConfig get paymentConfig => widget.paymentConfig;

  PaymentTheme get theme => paymentConfig.theme;

  Map getOrderParams() {
    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": widget.transactions,
      "note_to_payer": widget.note,
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL},
    };
    return temp;
  }

  @override
  void initState() {
    services = PaypalServices(
      sandboxMode: widget.sandboxMode!,
      clientId: widget.clientId!,
      secretKey: widget.secretKey!,
    );

    super.initState();
    Future.delayed(Duration.zero, () async {
      try {
        Map getToken = await services.getAccessToken();

        if (getToken['token'] != null) {
          accessToken = getToken['token'];
          final body = getOrderParams();
          final res = await services.createPaypalPayment(body, accessToken);

          if (res["approvalUrl"] != null) {
            setState(() {
              checkoutUrl = res["approvalUrl"];
              executeUrl = res["executeUrl"];
            });
          } else {
            widget.onError(res);
          }
        } else {
          widget.onError("${getToken['message']}");
        }
      } catch (e) {
        widget.onError(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(
      theme: paymentConfig.theme,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text("Paypal"),
          leading: CustomBackButton(),
          backgroundColor: theme.textColor.withAlpha(10),
          surfaceTintColor: Colors.transparent,
        ),
        body: Builder(
          builder: (context) {
            if (checkoutUrl == null) {
              return Center(child: widget.loadingIndicator ?? const CircularProgressIndicator());
            }

            return Stack(
              children: <Widget>[
                InAppWebView(
                  shouldOverrideUrlLoading: (controller, navigationAction) async {
                    final url = navigationAction.request.url;

                    if (url.toString().contains(returnURL)) {
                      exceutePayment(url, context);
                      return NavigationActionPolicy.CANCEL;
                    }
                    if (url.toString().contains(cancelURL)) {
                      return NavigationActionPolicy.CANCEL;
                    } else {
                      return NavigationActionPolicy.ALLOW;
                    }
                  },
                  initialUrlRequest: URLRequest(url: WebUri(checkoutUrl!)),
                  // initialOptions: InAppWebViewGroupOptions(
                  //   crossPlatform: InAppWebViewOptions(
                  //     useShouldOverrideUrlLoading: true,
                  //   ),
                  // ),
                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                  },
                  onCloseWindow: (InAppWebViewController controller) {
                    widget.onCancel();
                  },
                  onProgressChanged: (InAppWebViewController controller, int progress) {
                    if(!mounted) return;
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                ),
                progress < 1
                    ? SizedBox(height: 3, child: LinearProgressIndicator(value: progress))
                    : const SizedBox(),
              ],
            );
          },
        ),
      ),
    );
  }

  void exceutePayment(Uri? url, BuildContext context) {
    final payerID = url!.queryParameters['PayerID'];
    if (payerID != null) {
      services.executePayment(executeUrl, payerID, accessToken).then((id) {
        if (id['error'] == false) {
          widget.onSuccess(id);
        } else {
          widget.onError(id);
        }
      });
    } else {
      widget.onError('Something went wront PayerID == null');
    }
  }
}
