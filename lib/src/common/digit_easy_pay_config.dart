
import 'package:digit_easy_pay_flutter/digit_easy_pay_flutter.dart';

class DigitEasyPayConfig{
  final DigitEasyPayEnvironment environment;
  final String userKey;
  final String username;
  final String password;

//<editor-fold desc="Data Methods">
  const DigitEasyPayConfig({
    required this.environment,
    required this.userKey,
    required this.username,
    required this.password,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is DigitEasyPayConfig &&
              runtimeType == other.runtimeType &&
              environment == other.environment &&
              userKey == other.userKey &&
              username == other.username &&
              password == other.password);

  @override
  int get hashCode =>
      environment.hashCode ^
      userKey.hashCode ^
      username.hashCode ^
      password.hashCode;

  @override
  String toString() {
    return 'DigitEasyPayConfig{ environment: $environment, userKey: $userKey, username: $username, password: $password,}';
  }

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

  Map<String, dynamic> toMap() {
    return {
      'environment': this.environment,
      'userKey': this.userKey,
      'username': this.username,
      'password': this.password,
    };
  }

  factory DigitEasyPayConfig.fromMap(Map<String, dynamic> map) {
    return DigitEasyPayConfig(
      environment: map['environment'] as DigitEasyPayEnvironment,
      userKey: map['userKey'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }

//</editor-fold>
}