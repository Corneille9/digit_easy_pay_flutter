class FedapayConfig {
  final String apiKey;
  final String? callbackUrl;
  final Map<String, dynamic>? customer;
  final bool sandbox;

  FedapayConfig({required this.apiKey, this.callbackUrl, this.customer, this.sandbox = false});
}
