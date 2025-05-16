import '../../common/payment_constants.dart';

/// [QosicConfig] Class
///
/// This class represents the configuration settings required for initializing the [QosicConfig] SDK. It includes information about the environment, user key, username, and password needed for the integration.
class QosicConfig {
  final List<QosicPaymentGateway> paymentMethods;
  final String userKey;
  final String username;
  final String password;
  final String? applicationKey;
  final bool sandbox;

  QosicConfig({
    this.paymentMethods = QosicPaymentGateway.values,
    required this.userKey,
    required this.username,
    required this.password,
    this.applicationKey,
    this.sandbox = false,
  });
}
