import 'package:mybookstore/core/entities/store_entity.dart';
import 'package:mybookstore/core/extensions/map_extensions.dart';

enum UserRole {
  admin('Admin'),
  employee('Employee');

  const UserRole(this.value);

  final String value;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (e) => e.value == value,
      orElse: () => UserRole.employee,
    );
  }
}

class UserEntity {
  UserEntity({
    required this.name,
    this.role,
    this.username,
    this.id,
    this.password,
    this.store,
  });

  final int? id;
  final String name;
  final String? username;
  final String? password;
  final UserRole? role;

  final StoreEntity? store;

  bool get isAdmin => role == UserRole.admin;
  bool get isEmployee => role == UserRole.employee;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'password': password,
      'role': role?.value,
      'store': store?.toJson(),
    };
  }
}

class UserEntityFactory {
  static UserEntity fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json.getFromObject<int>('user.id'),
      name: json.getFromObject<String>('user.name'),
      role: UserRole.fromString(json.getFromObject<String>('user.role')),
      store: json['store'] != null ? StoreEntityFactory.fromJson(json) : null,
    );
  }
}
