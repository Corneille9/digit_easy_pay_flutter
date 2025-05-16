class StripeConfig {
  final String stripePrivateKey;
  final String stripePublishableKey;
  final String merchantCountryCode;
  final String merchantDisplayName;
  final String stripeApiUrl = "https://api.stripe.com/v1/payment_intents";
  final bool sandbox;

  const StripeConfig({
    required this.stripePrivateKey,
    required this.stripePublishableKey,
    required this.merchantCountryCode,
    required this.merchantDisplayName,
    this.sandbox = false,
  });
}
