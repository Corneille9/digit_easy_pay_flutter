class MobilePayResponse {
  final String comment;
  final String responseCode;
  final String responseMessage;
  final String transferRef;

  const MobilePayResponse({
    required this.comment,
    required this.responseCode,
    required this.responseMessage,
    required this.transferRef,
  });

  Map<String, dynamic> toMap() {
    return {
      'comment': this.comment,
      'responseCode': this.responseCode,
      'responseMessage': this.responseMessage,
      'transferRef': this.transferRef,
    };
  }

  factory MobilePayResponse.fromMap(Map<String, dynamic> map) {
    return MobilePayResponse(
      comment: map['comment'] ?? '',
      responseCode: map['responseCode'] ?? '',
      responseMessage: map['responseMessage'] ?? '',
      transferRef: map['transferRef'] as String,
    );
  }
}
