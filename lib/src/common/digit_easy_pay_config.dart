import 'package:digit_easy_pay_flutter/src/common/payment_constants.dart';

/// [DigitEasyPayConfig] Class
///
/// This class represents the configuration settings required for initializing the [DigitEasyPay] SDK. It includes information about the environment, user key, username, and password needed for the integration.
class DigitEasyPayConfig {
  final DigitEasyPayEnvironment environment;
  final String userKey;
  final String username;
  final String password;

  /// Constructor for the [DigitEasyPayConfig] class.
  ///
  /// Initializes the configuration with the provided environment, user key, username, and password.
  ///
  /// @param [environment] The environment for the [DigitEasyPay] integration (e.g., sandbox or live).
  /// @param [userKey] The user key associated with the integration.
  /// @param [username] The username for the integration.
  /// @param [password] The password for the integration.
  const DigitEasyPayConfig({
    required this.environment,
    required this.userKey,
    required this.username,
    required this.password,
  });

  /// Equality operator to compare two DigitEasyPayConfig objects for equality.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is DigitEasyPayConfig &&
              runtimeType == other.runtimeType &&
              environment == other.environment &&
              userKey == other.userKey &&
              username == other.username &&
              password == other.password);

  /// Computes a hash code for the DigitEasyPayConfig object.
  @override
  int get hashCode =>
      environment.hashCode ^
      userKey.hashCode ^
      username.hashCode ^
      password.hashCode;

  /// Converts the DigitEasyPayConfig object to a string representation.
  @override
  String toString() {
    return 'DigitEasyPayConfig{ environment: $environment, userKey: $userKey, username: $username, password: $password }';
  }

  /// Create a copy of the [DigitEasyPayConfig] object with optional fields replaced.
  ///
  /// @param environment The environment to replace the existing environment with (optional).
  /// @param userKey The user key to replace the existing user key with (optional).
  /// @param username The username to replace the existing username with (optional).
  /// @param password The password to replace the existing password with (optional).
  DigitEasyPayConfig copyWith({
    DigitEasyPayEnvironment? environment,
    String? userKey,
    String? username,
    String? password,
  }) {
    return DigitEasyPayConfig(
      environment: environment ?? this.environment,
      userKey: userKey ?? this.userKey,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  /// Converts the DigitEasyPayConfig object to a map representation.
  ///
  /// @return A map with the configuration properties.
  Map<String, dynamic> toMap() {
    return {
      'environment': this.environment,
      'userKey': this.userKey,
      'username': this.username,
      'password': this.password,
    };
  }

  /// Factory method to create a DigitEasyPayConfig object from a map.
  ///
  /// @param map A map containing the configuration properties.
  /// @return A DigitEasyPayConfig object.
  factory DigitEasyPayConfig.fromMap(Map<String, dynamic> map) {
    return DigitEasyPayConfig(
      environment: map['environment'] as DigitEasyPayEnvironment,
      userKey: map['userKey'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }
}
