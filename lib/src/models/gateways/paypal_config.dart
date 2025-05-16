class PayPalConfig {
  final String clientId;
  final String clientSecret;
  final bool sandbox;

  PayPalConfig({
    required this.clientId,
    required this.clientSecret,
    this.sandbox = true,
  });
}
