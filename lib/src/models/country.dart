class Country {
  final int id;
  final String name;
  final String code;
  final String dialCode;

//<editor-fold desc="Data Methods">

  const Country({
    required this.id,
    required this.name,
    required this.code,
    required this.dialCode,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Country &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          code == other.code &&
          dialCode == other.dialCode);

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ code.hashCode ^ dialCode.hashCode;

  @override
  String toString() {
    return 'Country{ id: $id, name: $name, code: $code, dialCode: $dialCode,}';
  }

  Country copyWith({
    int? id,
    String? name,
    String? code,
    String? dialCode,
  }) {
    return Country(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      dialCode: dialCode ?? this.dialCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'code': this.code,
      'dialCode': this.dialCode,
    };
  }

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      id: map['id'] as int,
      name: map['name'] as String,
      code: map['code'] as String,
      dialCode: map['dialCode'] as String,
    );
  }

//</editor-fold>
}
