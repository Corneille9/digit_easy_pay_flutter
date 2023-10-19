class CardPayResponse{
  final String responseCode;
  final String token;
  final String url;
  final String reference;

//<editor-fold desc="Data Methods">

  const CardPayResponse({
    required this.responseCode,
    required this.token,
    required this.url,
    required this.reference,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardPayResponse &&
          runtimeType == other.runtimeType &&
          responseCode == other.responseCode &&
          token == other.token &&
          url == other.url);

  @override
  int get hashCode => responseCode.hashCode ^ token.hashCode ^ url.hashCode;

  @override
  String toString() {
    return 'CardPayResponse{ responseCode: $responseCode, token: $token, url: $url, reference: $reference,}';
  }

  CardPayResponse copyWith({
    String? responseCode,
    String? token,
    String? url,
    String? reference,
  }) {
    return CardPayResponse(
      responseCode: responseCode ?? this.responseCode,
      token: token ?? this.token,
      url: url ?? this.url,
      reference: reference ?? this.reference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'responseCode': this.responseCode,
      'token': this.token,
      'url': this.url,
      'reference': this.reference,
    };
  }

  factory CardPayResponse.fromMap(Map<String, dynamic> map) {
    return CardPayResponse(
      responseCode: map['responseCode']??'',
      token: map['token']??'',
      url: map['url']??'',
      reference: map['reference'] as String,
    );
  }

//</editor-fold>
}