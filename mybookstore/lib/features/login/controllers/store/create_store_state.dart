import 'package:equatable/equatable.dart';
import 'package:mybookstore/core/enums/state_status.dart';

class CreateStoreState extends Equatable {
  const CreateStoreState({
    this.status = StateStatus.initial,
    this.name,
    this.slogan,
    this.adminName,
    this.adminUsername,
    this.adminPassword,
    this.adminPasswordConfirmation,
  });

  final StateStatus status;

  final String? name;
  final String? slogan;
  final String? adminName;
  final String? adminUsername;
  final String? adminPassword;
  final String? adminPasswordConfirmation;

  @override
  List<Object?> get props => [
        status,
        name,
        slogan,
        adminName,
        adminUsername,
        adminPassword,
        adminPasswordConfirmation,
      ];

  CreateStoreState copyWith({
    StateStatus? status,
    String? name,
    String? slogan,
    String? adminName,
    String? adminUsername,
    String? adminPassword,
    String? adminPasswordConfirmation,
  }) =>
      CreateStoreState(
        status: status ?? this.status,
        name: name ?? this.name,
        slogan: slogan ?? this.slogan,
        adminName: adminName ?? this.adminName,
        adminUsername: adminUsername ?? this.adminUsername,
        adminPassword: adminPassword ?? this.adminPassword,
        adminPasswordConfirmation:
            adminPasswordConfirmation ?? this.adminPasswordConfirmation,
      );
}
