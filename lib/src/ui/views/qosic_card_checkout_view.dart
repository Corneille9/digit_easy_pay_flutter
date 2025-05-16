import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../common/payment_l10n.dart';
import '../../common/payment_theme.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/theme_widget.dart';

/// A WebView for FedaPay payment checkout
class QosicCardCheckoutView extends StatefulWidget {
  /// The payment theme
  final PaymentTheme theme;

  /// The localization
  final L10n l10n;

  /// The checkout URL
  final String checkoutUrl;

  /// Creates a new FedaPay checkout view
  const QosicCardCheckoutView({
    super.key,
    required this.theme,
    required this.l10n,
    required this.checkoutUrl,
  });

  @override
  State<QosicCardCheckoutView> createState() => _QosicCardCheckoutViewState();
}

class _QosicCardCheckoutViewState extends State<QosicCardCheckoutView> {
  /// Loading progress (0-1)
  double _progress = 0;

  /// Success URL pattern to detect successful payments
  final String _successPattern = "status=SUCCESSFUL";

  /// Cancel URL pattern to detect cancelled payments
  final String _cancelPattern = "status=FAILED";

  final String _pendingPattern = "status=PENDING";

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: ThemeWidget(
        theme: widget.theme,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text("Qosic Card"),
            leading: CustomBackButton(
              onPressed: () {
                // Show confirmation dialog before cancelling
                _showCancelConfirmation(context);
              },
            ),
            backgroundColor: widget.theme.textColor.withAlpha(10),
            surfaceTintColor: Colors.transparent,
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Progress indicator
                if (_progress < 1)
                  LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: widget.theme.backgroundColor,
                    valueColor: AlwaysStoppedAnimation<Color>(widget.theme.primaryColor),
                  ),

                // WebView
                Expanded(child: _buildWebView()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the WebView for payment
  Widget _buildWebView() {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(widget.checkoutUrl)),
      onProgressChanged: (controller, progress) {
        setState(() {
          _progress = progress / 100;
        });
      },
      onLoadStart: (controller, url) {
        _checkPaymentStatus(url);
      },
      onLoadStop: (controller, url) {
        _checkPaymentStatus(url);
      },
      onReceivedError: (controller, request, error) {
        _checkPaymentStatus(request.url);
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        final url = navigationAction.request.url;
        if (url != null) {
          _checkPaymentStatus(url);
        }
        return NavigationActionPolicy.ALLOW;
      },
    );
  }

  /// Shows a confirmation dialog before cancelling payment
  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(widget.l10n.cancelPayment),
            content: Text(widget.l10n.wantToCancel),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(widget.l10n.no ?? 'No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Close payment screen
                },
                child: Text(widget.l10n.yes),
              ),
            ],
          ),
    );
  }

  /// Checks the URL for payment status indicators
  void _checkPaymentStatus(Uri? url) {
    if (url == null) return;

    final urlString = url.toString();

    // Check for success pattern
    if (urlString.contains(_successPattern)) {
      Navigator.pop(context, true);
    }
    // Check for cancel pattern
    else if (urlString.contains(_cancelPattern) || urlString.contains(_pendingPattern)) {
      Navigator.pop(context);
    }
  }
}
