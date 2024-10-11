import 'dart:convert';

class MusilyUser {
  final String id;
  final String name;
  final String email;

  MusilyUser({required this.id, required this.name, required this.email});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
    };
  }

  factory MusilyUser.fromMap(Map<String, dynamic> map) {
    return MusilyUser(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MusilyUser.fromJson(String source) =>
      MusilyUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MusilyUser(id: $id, name: $name, email: $email)';
}
