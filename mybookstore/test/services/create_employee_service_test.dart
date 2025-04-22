import 'package:eagle_http/eagle_http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mybookstore/core/entities/employee_entity.dart';
import 'package:mybookstore/core/errors/errors.dart';
import 'package:mybookstore/features/employees/data/impl/create_employee_service.dart';

import '../mocks/mock_http_client.dart';

void main() {
  late MockEagleHttp mockHttp;
  late CreateEmployeeService service;
  late EmployeeEntity testEmployee;

  setUp(() {
    mockHttp = MockEagleHttp();
    service = CreateEmployeeService(http: mockHttp);
    testEmployee = EmployeeEntity(
      name: 'João Silva',
      username: 'joao.silva@exemplo.com',
      password: 'senha123',
    );

    registerFallbackValue(EagleHttpMethod.get);
    registerFallbackValue(EagleRequest());

    final defaultResponse = MockEagleResponse();
    when(() => defaultResponse.data).thenReturn({});
    when(() => defaultResponse.statusCode).thenReturn(200);

    when(
      () => mockHttp.request(
        any(),
        method: any(named: 'method'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => defaultResponse);
  });

  group('CreateEmployeeService', () {
    test('deve retornar sucesso quando funcionário é criado', () async {
      final mockResponse = MockEagleResponse();
      when(() => mockResponse.statusCode).thenReturn(201);
      when(() => mockResponse.data).thenReturn(null);

      when(
        () => mockHttp.request(
          'v1/store/1/employee',
          method: EagleHttpMethod.post,
          options: captureAny(named: 'options'),
        ),
      ).thenAnswer((invocation) {
        return Future.value(mockResponse);
      });

      await service.call(testEmployee, 1);

      verify(
        () => mockHttp.request(
          'v1/store/1/employee',
          method: EagleHttpMethod.post,
          options: any(
            named: 'options',
            that: predicate<EagleRequest>((options) {
              final body = options.body as Map<String, dynamic>;
              return body['name'] == 'João Silva' &&
                  body['username'] == 'joao.silva@exemplo.com' &&
                  body['password'] == 'senha123';
            }),
          ),
        ),
      ).called(1);
    });

    test('deve retornar erro quando a requisição falha', () async {
      when(
        () => mockHttp.request(
          any(),
          method: any(named: 'method'),
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('Falha na conexão'));

      final result = await service.call(testEmployee, 1);

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ApiError>());
      expect(result.failure.message, equals('Erro ao criar funcionário'));
      expect(result.failure.code, equals(ErrorCodes.api));
    });

    test('deve incluir o id da loja na URL', () async {
      final storeId = 42;

      await service.call(testEmployee, storeId);

      verify(
        () => mockHttp.request(
          'v1/store/$storeId/employee',
          method: EagleHttpMethod.post,
          options: any(named: 'options'),
        ),
      ).called(1);
    });
  });
}
