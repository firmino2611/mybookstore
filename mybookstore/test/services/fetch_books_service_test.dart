import 'package:eagle_http/eagle_http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mybookstore/features/home/data/impl/fetch_books_service.dart';

import '../mocks/mock_http_client.dart';

void main() {
  late MockEagleHttp mockHttp;
  late FetchBooksService fetchBooksService;

  setUp(() {
    mockHttp = MockEagleHttp();
    fetchBooksService = FetchBooksService(http: mockHttp);

    registerFallbackValue(EagleHttpMethod.get);
    registerFallbackValue(EagleRequest());
  });

  group('FetchBooksService', () {
    final mockBooksData = [
      {
        'id': 1,
        'title': 'Clean Code',
        'author': 'Robert C. Martin',
        'synopsis': 'Um clássico sobre programação',
        'year': 2008,
        'rating': 4,
        'available': true,
      },
      {
        'id': 2,
        'title': 'Domain-Driven Design',
        'author': 'Eric Evans',
        'synopsis': 'Abordagem de design de software',
        'year': 2003,
        'rating': 4,
        'available': false,
      },
    ];

    test('deve retornar lista de livros quando a requisição for bem-sucedida',
        () async {
      final mockResponse = MockEagleResponse();
      when(() => mockResponse.data).thenReturn(mockBooksData);
      when(() => mockResponse.statusCode).thenReturn(200);

      when(
        () => mockHttp.request(
          'v1/store/1/book',
          method: any(named: 'method'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => mockResponse);

      final result = await fetchBooksService.fetchBooks(
        1,
        (
          title: 'Clean',
          author: null,
          rating: null,
          available: null,
          yearStart: null,
          yearEnd: null,
        ),
      );

      verify(
        () => mockHttp.request(
          'v1/store/1/book',
          method: EagleHttpMethod.get,
          options: any(
            named: 'options',
            that: predicate<EagleRequest>((options) {
              final queryParams = options.queryParameters ?? {};
              return queryParams['title'] == 'Clean';
            }),
          ),
        ),
      ).called(1);

      expect(result.isSuccess, isTrue);
    });

    test('deve aplicar filtros corretamente na consulta de livros', () async {
      final mockResponse = MockEagleResponse();
      when(() => mockResponse.data).thenReturn(mockBooksData);
      when(() => mockResponse.statusCode).thenReturn(200);

      when(
        () => mockHttp.request(
          any(),
          method: any(named: 'method'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => mockResponse);

      final filter = (
        title: 'Clean',
        author: 'Martin',
        rating: 4.0,
        available: true,
        yearStart: 2000,
        yearEnd: 2010,
      );

      await fetchBooksService.fetchBooks(1, filter);

      verify(
        () => mockHttp.request(
          'v1/store/1/book',
          method: EagleHttpMethod.get,
          options: any(
            named: 'options',
            that: predicate<EagleRequest>((options) {
              final queryParams = options.queryParameters ?? {};
              return queryParams['title'] == 'Clean' &&
                  queryParams['author'] == 'Martin' &&
                  queryParams['rating'] == '4' &&
                  queryParams['available'] == true &&
                  queryParams['year-start'] == '2000' &&
                  queryParams['year-finish'] == '2010';
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

      final result = await fetchBooksService.fetchBooks(1);

      expect(result.isFailure, isTrue);
      expect(result.failure.message, contains('Falha na conexão'));
    });

    test('deve retornar erro quando a resposta não é uma lista', () async {
      final mockResponse = MockEagleResponse();
      when(() => mockResponse.data).thenReturn({'erro': 'Formato inválido'});
      when(() => mockResponse.statusCode).thenReturn(200);

      when(
        () => mockHttp.request(
          any(),
          method: any(named: 'method'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => mockResponse);

      final result = await fetchBooksService.fetchBooks(1);

      expect(result.isFailure, isTrue);
      expect(result.failure.message, equals('Erro ao fazer login'));
    });
  });
}
