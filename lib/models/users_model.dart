import 'dart:convert';

class UserModel {
  final int? id;
  final String? name;
  final String? username;
  final String email;
  final String? phone;
  final String password;

  UserModel({
    this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
  });

  // Convert ke Map (untuk database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }

  // Convert dari Map ke objek
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      username: map['username'],
      email: map['email'],
      phone: map['phone'],
      password: map['password'],
    );
  }

  // Convert ke JSON (opsional untuk API/penyimpanan lokal)
  String toJson() => json.encode(toMap());

  // Convert dari JSON
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
