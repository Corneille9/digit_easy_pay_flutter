### DigitEasyPayFlutter

A comprehensive payment processing library for Flutter applications that provides a unified
interface for integrating multiple payment gateways. This library makes it easy to offer various
payment options to your users with minimal code and consistent UI.

[DigitEasyPayFlutter - Github](https://github.com/Corneille9/digit_easy_pay_flutter.git)

## Features

- **Multiple Payment Gateways**: Support for Stripe, PayPal, FedaPay, and Qosic payment gateways
- **Unified API**: Process payments with a consistent API regardless of the gateway
- **Customizable UI**: Easily theme the payment UI to match your app's design
- **Localization**: Built-in support for multiple languages (English, French, Chinese)
- **Automatic Gateway Selection**: Automatically use the appropriate gateway when only one is
  available
- **Currency Support**: Extensive support for different currencies
- **Mobile Money Integration**: Support for mobile money payments in supported regions
- **Automatic Currency Conversion**: Converts currencies when a payment method doesn't support the
  specified currency

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  digit_easy_pay_flutter:
    git:
      url: https://github.com/Corneille9/digit_easy_pay_flutter.git
      ref: main
```

Then run:

```shell
flutter pub get
```

## Getting Started

### 1. Configure the Library

Initialize the library with your payment gateway configurations. **Important**: You must call
`setConfig()` before using any other functionality in the library.

```dart
import 'package:digit_easy_pay_flutter/digit_easy_pay_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  // Configure the payment library
  DigitEasyPayFlutter.setConfig(
    PaymentConfig(
      // Currency converter credentials (required for automatic currency conversion)
      currencyConverterCredentials: Credentials(
        username: 'your_converter_username',
        password: 'your_converter_password',
      ),
      
      // Configure payment gateways
      gatewayConfig: PaymentGatewayConfig(
        stripeConfig: StripeConfig(
          stripePrivateKey: 'your_stripe_private_key',
          stripePublishableKey: 'your_stripe_publishable_key',
          merchantCountryCode: 'US',
          merchantDisplayName: 'Your Store Name',
        ),
        payPalConfig: PayPalConfig(
          clientId: 'your_paypal_client_id',
          clientSecret: 'your_paypal_client_secret',
          sandbox: true, // Set to false for production
        ),
        fedapayConfig: FedapayConfig(
          apiKey: 'your_fedapay_api_key',
          sandbox: true, // Set to false for production
        ),
        qosicConfig: QosicConfig(
          userKey: 'your_qosic_user_key',
          username: 'your_qosic_username',
          password: 'your_qosic_password',
          paymentMethods: [QosicPaymentGateway.momo, QosicPaymentGateway.flooz],
          sandbox: true, // Set to false for production
        ),
      ),
      
      // Optionally specify which gateways to enable (defaults to all)
      gateways: [PaymentGateway.STRIPE, PaymentGateway.PAYPAL],
      
      // Customize the UI theme (optional)
      theme: DefaultPaymentTheme(),
      
      // Set the language (optional, defaults to French)
      lang: L10nEn(),
    ),
  );

  runApp(MyApp());
}
```

### 2. Process a Payment

To process a payment, simply call the `checkout` method:

```dart
Future<void> processPayment() async {
  final paymentResponse = await DigitEasyPayFlutter.checkout(
    context: context,
    paymentRequest: PaymentRequest(
      amount: 100.0,
      currency: Currency.USD,
    ),
  );

  if (paymentResponse != null) {
    // Payment was successful
    print('Payment successful!');
    print('Reference: ${paymentResponse.reference}');
    print('Gateway: ${paymentResponse.gateway}');
    print('Method: ${paymentResponse.gatewayMethod}');
  } else {
    // Payment was cancelled or failed
    print('Payment was not completed');
  }
}
```

## Supported Payment Gateways

### Stripe

Stripe is a global payment processor that supports credit cards and other payment methods.

```dart
StripeConfig(
  stripePrivateKey: 'your_stripe_private_key',
  stripePublishableKey: 'your_stripe_publishable_key',
  merchantCountryCode: 'US',
  merchantDisplayName: 'Your Store Name',
  sandbox: false, // Set to true for testing
)
```

### dart

PayPal is a widely used online payment system that supports credit cards and PayPal accounts.

```dart
PayPalConfig(
  clientId: 'your_paypal_client_id',
  clientSecret: 'your_paypal_client_secret',
  sandbox: true, // Set to false for production
)
```

### FedaPay

FedaPay is a payment gateway focused on African markets.

```dart
FedapayConfig(
  apiKey: 'your_fedapay_api_key',
  callbackUrl: 'your_callback_url', // Optional
  customer: { /* Customer details */ }, // Optional
  sandbox: true, // Set to false for production
)
```

### Qosic

Qosic supports mobile money payments in various African countries.

```dart
QosicConfig(
  userKey: 'your_qosic_user_key',
  username: 'your_qosic_username',
  password: 'your_qosic_password',
  applicationKey: 'your_application_key', // Optional
  paymentMethods: [
    QosicPaymentGateway.momo, 
    QosicPaymentGateway.flooz, 
    QosicPaymentGateway.visa
  ],
  sandbox: true, // Set to false for production
)
```

## Customization

### Theming

You can customize the appearance of the payment UI by providing a custom theme:

```dart
// Use the default light theme
theme: DefaultPaymentTheme(),

// Use the dark theme
theme: DarkPaymentTheme(),

// Create a custom theme
theme: DefaultPaymentTheme(
  primaryColor: Colors.blue,
  backgroundColor: Colors.white,
  textColor: Colors.black,
  errorColor: Colors.red,
  // ... other customizations
),
```

### Localization

The library supports multiple languages out of the box:

```dart
// English
lang: L10nEn(),

// French (default)
lang: L10nFr(),

// Chinese
lang: L10nCn(),

// Custom localization
lang: L10nEn(
  pay: "Proceed to Payment",
  cancelPayment: "Abort Payment",
  // ... other custom translations
),
```

## Advanced Usage

### Automatic Currency Conversion

The library automatically converts currencies when a payment method doesn't support the currency
specified in your payment request. This requires setting up the `currencyConverterCredentials` in
your `PaymentConfig`:

```dart
PaymentConfig(
  currencyConverterCredentials: Credentials(
    username: 'your_converter_username',
    password: 'your_converter_password',
  ),
  // ... other configurations
)
```

For example, if you specify a payment in USD but the selected payment method only supports XOF, the
library will automatically convert the amount before processing the payment.

### Handling External Transactions

If you need to save external transactions to backend:

```dart
// Important: Make sure DigitEasyPayFlutter.setConfig() has been called first
Future<void> saveExternalTransaction() async {
  await DigitEasyPayFlutter().notifyExternalTransaction({
    'amount': 100.0,
    'currency': 'USD',
    'reference': 'tx_123456',
    'gateway': 'stripe',
    'status': 'success',
    // ... other transaction details
  });
}
```

## Payment Flow

1. Call `DigitEasyPayFlutter.checkout()` with your payment request
2. If multiple payment gateways are available, the user selects one
3. The appropriate payment flow is initiated based on the selected gateway
4. The user completes the payment process
5. A `PaymentResponse` is returned if successful, or `null` if cancelled/failed

## Error Handling

The library provides comprehensive error handling:

```dart
try {
  final response = await DigitEasyPayFlutter.checkout(
    context: context,
    paymentRequest: PaymentRequest(
      amount: 100.0,
      currency: Currency.USD,
    ),
  );
  
  // Handle successful payment
} on PaymentException catch (e) {
  // Handle payment-specific errors
  print('Payment error: ${e.message}');
} catch (e) {
  // Handle other errors
  print('Error: $e');
}
```

## Example App

Here's a complete example of a payment screen:

```dart
import 'package:digit_easy_pay_flutter/digit_easy_pay_flutter.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total: \$100.00',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _processPayment(context),
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processPayment(BuildContext context) async {
    try {
      final response = await DigitEasyPayFlutter.checkout(
        context: context,
        paymentRequest: PaymentRequest(
          amount: 100.0,
          currency: Currency.USD,
        ),
      );

      if (response != null) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment successful! Reference: ${response.reference}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
```

## Supported Currencies

The library supports a wide range of currencies, including:

- USD (US Dollar)
- EUR (Euro)
- XOF (West African CFA Franc)
- And many more...

Use the `Currency` enum to specify the currency for your payment:

```dart
PaymentRequest(
  amount: 100.0,
  currency: Currency.USD,
)
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

If you encounter any issues or have questions, please file an issue on the GitHub repository.