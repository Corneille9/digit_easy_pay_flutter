
---

# Digit Easy Pay flutter

`digit_easy_pay_flutter` is a Flutter package that simplifies the integration of mobile and card payment features into your applications using the Digit Easy Pay platform.

## Features

- **Mobile Payments**: Accept mobile payments through various payment methods such as MTN Mobile Money, Orange Money, and more.

- **Card Payments**: Provide your users with the option to securely make credit or debit card payments.

- **Real-time Tracking**: Get real-time updates on the transaction status for a seamless user experience.

- **International Data**: Access information on countries, currencies, and more to simplify international transactions.

## Installation

To use `digit_easy_pay_flutter`, add it to the `dependencies` section of your `pubspec.yaml` file:

```yaml
dependencies:
  digit_easy_pay_flutter: ^1.0.0
```

Then, run `flutter pub get` to download and install the package.

## Usage

### Quick Checkout

You can enable a quick checkout experience using the built-in views provided by the package. Here's an example:

```dart
import 'package:digit_easy_pay_flutter/digit_easy_pay_flutter.dart';

void main() {
  final config = DigitEasyPayConfig(
    environment: DigitEasyPayEnvironment.sandbox, // Use "live" for production mode
    userKey: 'your_user_key',
    username: 'your_username',
    password: 'your_password',
  );

  final digitEasyPay = DigitEasyPay(config);

  // Initialize the service
  digitEasyPay.initialize();

  // Perform a quick checkout with options
  digitEasyPay.checkout(
    context,
    amount: 1,
    currency: DigitEasyPayCurrency.XOF, // Currency (default is XOF)
    l10n: L10nEn(), // Language settings (you can use L10nFr, L10nCn, or create your own)
    theme: DefaultPaymentTheme.light(), // Payment theme (you can also use DarkPaymentTheme or create a custom theme)
  );

  // When you're done, make sure to release resources
  digitEasyPay.dispose();
}
```

### Custom Implementation

Alternatively, you can implement your own views and use the following methods to handle payments:

- `digitEasyPay.makeCardPayment`: Perform card payments.
- `digitEasyPay.makeMobilePayment`: Perform mobile payments.

To track the status of a transaction, you can use the `PaymentStatusStreamManager` class. Here's an example:

```dart
import 'package:digit_easy_pay_flutter/digit_easy_pay_flutter.dart';

// Initialize DigitEasyPay and perform payments

final digitEasyPay = DigitEasyPay(config);

// Make card payment
final cardPaymentResponse = await digitEasyPay.makeCardPayment(charge);

// Get the URL for redirection
final redirectionUrl = cardPaymentResponse.url;

// Perform mobile payment
final mobilePaymentResponse = await digitEasyPay.makeMobilePayment(
  method: DigitEasyPayPaymentMethod.visa, // Payment method
  charge: mobilePayRequest,
);

// Get the transaction reference
final transactionReference = mobilePaymentResponse.transferRef;

// Set up a stream manager to track transaction status
final statusStreamManager = PaymentStatusStreamManager(
  digitEasyPay.provider,
  reference: transactionReference,
  onTimeOut: () {
    // Handle timeout
  },
);

statusStreamManager.statusTransactionStream.listen((TransactionStatus status) {
  if (status == TransactionStatus.PENDING) {
    // Handle pending status
  } else if (status == TransactionStatus.SUCCESSFUL) {
    // Handle successful status
  } else if (status == TransactionStatus.FAILED) {
    // Handle failed status
  }
});

// Don't forget to dispose of the stream manager when done
statusStreamManager.dispose();
```

## Support

If you encounter any issues or have questions, feel free to [open an issue](https://github.com/Corneille9/digit_easy_pay_flutter/issues) on GitHub.

---

Please customize this README to match your specific use case with the `digit_easy_pay_flutter` package. Make sure to update any links to the GitHub repository and provide any additional instructions needed for your users.