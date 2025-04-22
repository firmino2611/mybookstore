import 'package:equatable/equatable.dart';
import 'package:mybookstore/core/entities/employee_entity.dart';
import 'package:mybookstore/core/enums/state_status.dart';

class EmployeeFormState extends Equatable {
  factory EmployeeFormState.fromEmployee(EmployeeEntity employee) {
    return EmployeeFormState(
      name: employee.name,
      username: employee.username,
      password: employee.password,
    );
  }

  const EmployeeFormState({
    this.name,
    this.username,
    this.password,
    this.status = StateStatus.initial,
  });

  final String? name;
  final String? username;
  final String? password;

  final StateStatus status;

  EmployeeEntity toEmployeeEntity() {
    return EmployeeEntity(
      name: name ?? '',
      username: username ?? '',
      password: password ?? '',
    );
  }

  bool get isValid {
    return name != null && username != null && password != null;
  }

  EmployeeFormState copyWith({
    String? name,
    String? username,
    String? password,
    StateStatus? status,
  }) {
    return EmployeeFormState(
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [name, username, password, status];
}
