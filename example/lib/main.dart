import 'package:digit_easy_pay_flutter/digit_easy_pay_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  // Initialize the payment library with configuration
  DigitEasyPayFlutter.setConfig(
    PaymentConfig(
      // Currency converter credentials for automatic currency conversion
      currencyConverterCredentials: Credentials(username: 'your_converter_username', password: 'your_converter_password'),

      // Configure payment gateways
      gatewayConfig: PaymentGatewayConfig(
        stripeConfig: StripeConfig(
          stripePrivateKey: 'your_stripe_private_key',
          stripePublishableKey: 'your_stripe_publishable_key',
          merchantCountryCode: 'US',
          merchantDisplayName: 'Digit Easy Pay Demo',
        ),

        payPalConfig: PayPalConfig(
          clientId: 'your_paypal_client_id',
          clientSecret: 'your_paypal_client_secret',
          sandbox: true, // Use sandbox for testing
        ),

        fedapayConfig: FedapayConfig(
          apiKey: 'your_fedapay_api_key',
          sandbox: true, // Use sandbox for testing
        ),

        qosicConfig: QosicConfig(
          userKey: 'your_qosic_user_key',
          username: 'your_qosic_username',
          password: 'your_qosic_password',
          paymentMethods: [QosicPaymentGateway.momo, QosicPaymentGateway.flooz, QosicPaymentGateway.visa],
          sandbox: true, // Use sandbox for testing
        ),
      ),

      // Optionally specify which gateways to enable (defaults to all)
      // gateways: [PaymentGateway.STRIPE, PaymentGateway.PAYPAL],

      // Set theme and language
      theme: DefaultPaymentTheme(),
      lang: L10nEn(),
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digit Easy Pay Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: const MyHomePage(title: 'Digit Easy Pay Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isProcessing = false;
  String? _paymentResult;

  Future<void> _processPayment() async {
    // Prevent multiple payment attempts
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _paymentResult = null;
    });

    try {
      // Create payment request
      final paymentRequest = PaymentRequest(
        amount: 100.0, // Amount to charge
        currency: Currency.USD, // Currency
      );

      // Process the payment
      final response = await DigitEasyPayFlutter.checkout(context: context, paymentRequest: paymentRequest);

      // Handle the response
      if (response != null) {
        setState(() {
          _paymentResult =
              'Payment successful!\nReference: ${response.reference}\n'
              'Gateway: ${response.gateway}\n'
              'Method: ${response.gatewayMethod ?? "N/A"}';
        });
      } else {
        setState(() {
          _paymentResult = 'Payment was cancelled or failed';
        });
      }
    } catch (e) {
      setState(() {
        _paymentResult = 'Error: $e';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Payment amount display
              const Text('Demo Payment', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Amount: \$100.00', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 30),

              // Checkout button
              ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                child: _isProcessing ? const CircularProgressIndicator() : const Text("Checkout", style: TextStyle(fontSize: 16)),
              ),

              // Result display
              if (_paymentResult != null) ...[
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: _paymentResult!.contains('successful') ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _paymentResult!.contains('successful') ? Colors.green : Colors.red),
                  ),
                  child: Text(_paymentResult!, style: TextStyle(color: _paymentResult!.contains('successful') ? Colors.green.shade800 : Colors.red.shade800)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
