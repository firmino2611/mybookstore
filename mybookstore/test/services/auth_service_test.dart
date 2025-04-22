import 'package:eagle_http/eagle_http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mybookstore/core/errors/errors.dart';
import 'package:mybookstore/features/login/data/services/impl/auth_service.dart';

import '../mocks/mock_http_client.dart';

void main() {
  late MockEagleHttp mockHttp;
  late AuthService authService;

  setUp(() {
    mockHttp = MockEagleHttp();
    authService = AuthService(http: mockHttp);

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

  group('AuthService', () {
    test('deve retornar usuário quando login é bem-sucedido', () async {
      final mockResponse = MockEagleResponse();

      // Configurando a resposta fake do mock
      final mockData = {
        'token': 'abc123',
        'refreshToken': 'xyz789',
        'user': {
          'id': 1,
          'name': 'Usuário Teste',
          'username': 'teste@example.com',
          'role': 'Admin',
        },
        'store': {
          'id': 1,
          'name': 'Livraria Teste',
          'slogan': 'Leia mais, saiba mais',
        },
      };

      when(() => mockResponse.data).thenReturn(mockData);
      when(() => mockResponse.statusCode).thenReturn(200);

      when(
        () => mockHttp.request(
          'v1/auth',
          method: EagleHttpMethod.post,
          options: captureAny(named: 'options'),
        ),
      ).thenAnswer((_) {
        return Future.value(mockResponse);
      });

      when(() => mockHttp.setHeaders(any())).thenAnswer((_) async {});

      final result = await authService.call(
        'teste@example.com',
        'senha123',
      );

      expect(result.isSuccess, isTrue);

      final authData = result.success;
      expect(authData.token, equals('abc123'));
      expect(authData.refreshToken, equals('xyz789'));
      expect(authData.user.name, equals('Usuário Teste'));

      verify(
        () => mockHttp.setHeaders({
          'Authorization': 'Bearer abc123',
        }),
      ).called(1);
    });

    test('deve retornar erro quando login falha', () async {
      when(
        () => mockHttp.request(
          any(),
          method: any(named: 'method'),
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('Falha na autenticação'));

      final result = await authService.call(
        'invalido@example.com',
        'senhaerrada',
      );

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ApiError>());
      expect(result.failure.message, contains('Falha na autenticação'));
    });

    test('deve retornar erro quando a resposta não é um Map', () async {
      final mockResponse = MockEagleResponse();

      when(() => mockResponse.data).thenReturn(['dado inválido']);
      when(() => mockResponse.statusCode).thenReturn(200);

      when(
        () => mockHttp.request(
          any(),
          method: any(named: 'method'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => mockResponse);

      final result = await authService.call('teste@example.com', 'senha123');

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ApiError>());
      expect(result.failure.message, equals('Erro ao fazer login'));
    });
  });
}
