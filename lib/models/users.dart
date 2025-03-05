class User {
  int? id;
  String name;
  String cedula;
  String address;
  String code;
  String phoneNumber;
  DateTime sentAt;

  User({
    this.id,
    required this.name,
    required this.cedula,
    required this.address,
    required this.code,
    required this.phoneNumber,
    required this.sentAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cedula': cedula,
      'address': address,
      'code': code,
      'phoneNumber': phoneNumber,
      'sentAt': sentAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      cedula: map['cedula'],
      address: map['address'],
      code: map['code'],
      phoneNumber: map['phoneNumber'],
      sentAt: DateTime.parse(map['sentAt']),
    );
  }
}
