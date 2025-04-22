import 'package:eagle_http/eagle_http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mybookstore/core/errors/errors.dart';
import 'package:mybookstore/features/login/data/services/impl/auth_validate_token_service.dart';

import '../mocks/mock_http_client.dart';

void main() {
  late MockEagleHttp mockHttp;
  late AuthValidateTokenService service;

  setUp(() {
    mockHttp = MockEagleHttp();
    service = AuthValidateTokenService(http: mockHttp);

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

  group('AuthValidateTokenService', () {
    test('deve retornar usuário quando a validação do token é bem-sucedida',
        () async {
      final mockResponse = MockEagleResponse();

      final mockData = {
        'token': 'novo_token123',
        'refreshToken': 'novo_refresh789',
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
          'v1/auth/validateToken',
          method: EagleHttpMethod.post,
          options: captureAny(named: 'options'),
        ),
      ).thenAnswer((invocation) {
        final options = invocation.namedArguments[#options] as EagleRequest;
        expect(options.body, containsPair('refreshToken', 'token_existente'));

        return Future.value(mockResponse);
      });

      when(() => mockHttp.setHeaders(any())).thenAnswer((_) async {});

      final result = await service.call('token_existente');

      expect(result.isSuccess, isTrue);

      final authData = result.success;
      expect(authData.token, equals('novo_token123'));
      expect(authData.refreshToken, equals('novo_refresh789'));
      expect(authData.user.name, equals('Usuário Teste'));

      verify(
        () => mockHttp.setHeaders({
          'Authorization': 'Bearer novo_token123',
        }),
      ).called(1);
    });

    test('deve retornar erro quando a validação do token falha', () async {
      when(
        () => mockHttp.request(
          any(),
          method: any(named: 'method'),
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('Token inválido ou expirado'));

      final result = await service.call('token_invalido');

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ApiError>());
      expect(result.failure.message, contains('Token inválido ou expirado'));
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

      final result = await service.call('token_qualquer');

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ApiError>());
      expect(result.failure.message, equals('Erro ao fazer login'));
    });
  });
}
