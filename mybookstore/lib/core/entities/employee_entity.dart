import 'package:mybookstore/core/extensions/map_extensions.dart';

class EmployeeEntity {
  EmployeeEntity({
    required this.name,
    required this.username,
    this.id,
    this.password,
    this.photo,
  });

  final int? id;
  final String name;
  final String? photo;
  final String username;
  final String? password;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
      'username': username,
      'password': password,
    };
  }
}

class EmployeeEntityFactory {
  static EmployeeEntity fromJson(Map<String, dynamic> json) {
    return EmployeeEntity(
      id: json.get<int?>('id'),
      name: json.get<String>('name'),
      photo: json.get<String?>('photo'),
      username: json.get<String>('username'),
      password: json.get<String?>('password'),
    );
  }
}
