import 'package:eagle_http/eagle_http.dart';
import 'package:mybookstore/core/entities/employee_entity.dart';
import 'package:mybookstore/core/errors/either.dart';
import 'package:mybookstore/core/errors/errors.dart';
import 'package:mybookstore/core/extensions/map_extensions.dart';
import 'package:mybookstore/features/employees/data/i_update_employee_service.dart';

class UpdateEmployeeService implements IUpdateEmployeeService {
  UpdateEmployeeService({required this.http});

  final EagleHttpAbstract http;

  @override
  Future<Either<void, GlobalException>> call(
    EmployeeEntity employee,
    int storeId,
  ) async {
    try {
      await http.request(
        'v1/store/$storeId/employee/${employee.id}',
        method: EagleHttpMethod.put,
        options: EagleRequest(
          body: {
            'name': employee.name,
            'username': employee.username,
            'password': employee.password,
          }.removeNulls(),
        ),
      );

      return Either.success(null);
    } catch (e) {
      return Either.failure(
        ApiError('Erro ao criar funcionário', ErrorCodes.api),
      );
    }
  }
}
