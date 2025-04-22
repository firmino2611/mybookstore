import 'package:mybookstore/core/entities/user_entity.dart';
import 'package:mybookstore/core/extensions/map_extensions.dart';

class StoreEntity {
  StoreEntity({
    required this.name,
    required this.slogan,
    this.id,
    this.banner,
    this.admin,
  });

  final String? banner;
  final int? id;
  final String name;
  final String slogan;

  final UserEntity? admin;

  Map<String, dynamic> toJson() {
    return {
      'banner': banner,
      'id': id,
      'name': name,
      'slogan': slogan,
      'admin': admin?.toJson(),
    };
  }
}

class StoreEntityFactory {
  static StoreEntity fromJson(Map<String, dynamic> json) {
    return StoreEntity(
      // banner: json.getFromObject<String?>('store.banner'),
      id: json.getFromObject<int?>('store.id'),
      name: json.getFromObject<String>('store.name'),
      slogan: json.getFromObject<String>('store.slogan'),
      // admin: UserEntityFactory.fromJson(
      //   json.getFromObject<Map<String, dynamic>>('admin'),
      // ),
    );
  }
}
