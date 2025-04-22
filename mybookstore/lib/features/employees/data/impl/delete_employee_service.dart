import 'package:eagle_http/eagle_http.dart';
import 'package:mybookstore/core/errors/either.dart';
import 'package:mybookstore/core/errors/errors.dart';
import 'package:mybookstore/features/employees/data/i_delete_employee_service.dart';

class DeleteEmployeeService implements IDeleteEmployeeService {
  DeleteEmployeeService({required this.http});

  final EagleHttpAbstract http;

  @override
  Future<Either<void, GlobalException>> call(
    int employeeId,
    int storeId,
  ) async {
    try {
      await http.request(
        'v1/store/$storeId/employee/$employeeId',
        method: EagleHttpMethod.delete,
      );

      return Either.success(null);
    } catch (e) {
      return Either.failure(
        ApiError('Erro ao deletar funcionário', ErrorCodes.api),
      );
    }
  }
}
