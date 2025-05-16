class Transaction {
  final String id;
  final double amount;
  final String paymentMethod;
  final String reference;
  final String transactionType;

  //<editor-fold desc="Data Methods">

  const Transaction({
    required this.id,
    required this.amount,
    required this.paymentMethod,
    required this.reference,
    required this.transactionType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          amount == other.amount &&
          paymentMethod == other.paymentMethod &&
          reference == other.reference &&
          transactionType == other.transactionType);

  @override
  int get hashCode =>
      id.hashCode ^
      amount.hashCode ^
      paymentMethod.hashCode ^
      reference.hashCode ^
      transactionType.hashCode;

  @override
  String toString() {
    return 'Transaction{ id: $id, amount: $amount, paymentMethod: $paymentMethod, reference: $reference, transactionType: $transactionType,}';
  }

  Transaction copyWith({
    String? id,
    double? amount,
    String? paymentMethod,
    String? reference,
    String? transactionType,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      reference: reference ?? this.reference,
      transactionType: transactionType ?? this.transactionType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'amount': this.amount,
      'paymentMethod': this.paymentMethod,
      'reference': this.reference,
      'transactionType': this.transactionType,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      amount: map['amount'] ?? 0,
      paymentMethod: map['paymentMethod'] ?? '',
      reference: map['reference'] ?? '',
      transactionType: map['transactionType'] ?? '',
    );
  }

  //</editor-fold>
}
