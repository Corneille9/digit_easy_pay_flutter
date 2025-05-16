import '../common/form_request.dart';

class MobilePayRequest extends FormRequest{
  final String phoneNumber;
  final num amount;
  final String firstName;
  final String lastName;
  final String email;

  const MobilePayRequest({
    required this.phoneNumber,
    required this.amount,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  MobilePayRequest copyWith({
    String? phoneNumber,
    num? amount,
    String? firstName,
    String? lastName,
    String? email,
  }) {
    return MobilePayRequest(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      amount: amount ?? this.amount,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
    );
  }

  @override
  String toString() {
    return 'MobilePayRequest{phoneNumber: $phoneNumber, amount: $amount, firstName: $firstName, lastName: $lastName, email: $email}';
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': this.phoneNumber,
      'amount': this.amount,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'email': this.email,
    };
  }

  factory MobilePayRequest.fromMap(Map<String, dynamic> map) {
    return MobilePayRequest(
      phoneNumber: map['phoneNumber'] as String,
      amount: map['amount'] as num,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
    );
  }
}
