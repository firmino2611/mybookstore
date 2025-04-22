import 'package:eagle_http/eagle_http.dart';
import 'package:mybookstore/core/entities/employee_entity.dart';
import 'package:mybookstore/core/errors/either.dart';
import 'package:mybookstore/core/errors/errors.dart';
import 'package:mybookstore/features/employees/data/i_fetch_employees_service.dart';

class FetchEmployeesService implements IFetchEmployeesService {
  FetchEmployeesService({required this.http});

  final EagleHttpAbstract http;

  @override
  Future<Either<List<EmployeeEntity>, GlobalException>> call(
    int storeId,
  ) async {
    try {
      final response = await http.request(
        'v1/store/$storeId/employee',
        method: EagleHttpMethod.get,
      );

      if (response?.data is List) {
        return Either.success(
          (response?.data as List)
              .map((e) => EmployeeEntityFactory.fromJson(e))
              .toList(),
        );
      }

      return Either.failure(
        ApiError('Erro ao buscar funcionários', ErrorCodes.api),
      );
    } catch (e) {
      return Either.failure(
        ApiError('Erro ao buscar funcionários', ErrorCodes.api),
      );
    }
  }
}
