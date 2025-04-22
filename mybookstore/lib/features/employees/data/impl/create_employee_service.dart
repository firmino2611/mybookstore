import 'package:eagle_http/eagle_http.dart';
import 'package:mybookstore/core/entities/employee_entity.dart';
import 'package:mybookstore/core/errors/either.dart';
import 'package:mybookstore/core/errors/errors.dart';
import 'package:mybookstore/features/employees/data/i_create_employee_service.dart';

class CreateEmployeeService implements ICreateEmployeeService {
  CreateEmployeeService({required this.http});

  final EagleHttpAbstract http;

  @override
  Future<Either<void, GlobalException>> call(
    EmployeeEntity employee,
    int storeId,
  ) async {
    try {
      await http.request(
        'v1/store/$storeId/employee',
        method: EagleHttpMethod.post,
        options: EagleRequest(
          body: {
            'name': employee.name,
            'username': employee.username,
            'password': employee.password,
          },
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
