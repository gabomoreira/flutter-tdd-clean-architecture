import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manguinho/data/http/http_error.dart';
import 'package:manguinho/infra/http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:http/http.dart';
import 'http_adapter_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  late MockClient client;
  late HttpAdapter sut;
  late String url;
  late Map<String, String> defaultHeaders;
  late Uri mockedUri;

  setUp(() {
    client = MockClient();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
    defaultHeaders = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    mockedUri = sut.toUri(url);
  });
  
  group('post', () {
    PostExpectation mockRequest() => when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body')));

    void mockResponse(int statusCode, {String body = '{"any_key": "any_value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    setUp(() {
      mockResponse(200);
    });

    test('Should call post with correct values', () async {
      await sut.request(url: url, method: 'post');

      verify(client.post( 
        mockedUri, 
        headers: defaultHeaders,
      ));
    });

    test('Should call post with null body', () async {
      await sut.request(url: url, method: 'post');

      verify(client.post( 
        any,
        headers: anyNamed('headers'),
      ));
    });

    test('Should return data with returns 200', () async {
      final response = await sut.request(url: url, method: 'post');
 
      expect(response, {'any_key': 'any_value'});
    });

    test('Should return null if returns 200 with no data', () async {
      mockResponse(200, body: '');

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });
    
    test('Should return null if returns 204 with no data', () async {
      mockResponse(204, body: '');

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Should return null if returns 204 with data', () async {
      mockResponse(204);

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Should return BadRequestError if returns 400', () async {
      mockResponse(400);

      final response = sut.request(url: url, method: 'post');

      expect(response, throwsA(HttpError.badRequest));
    });

    test('Should return UnauthorizedError if returns 401', () async {
      mockResponse(401);

      final response = sut.request(url: url, method: 'post');

      expect(response, throwsA(HttpError.unauthorized));
    });

    test('Should return ForbiddenError if returns 403', () async {
      mockResponse(403);

      final response = sut.request(url: url, method: 'post');

      expect(response, throwsA(HttpError.forbidden));
    });

    test('Should return NotFoundError if returns 404', () async {
      mockResponse(404);

      final response = sut.request(url: url, method: 'post');

      expect(response, throwsA(HttpError.notFound));
    });

    test('Should return ServerError if returns 500', () async {
      mockResponse(500);

      final response = sut.request(url: url, method: 'post');

      expect(response, throwsA(HttpError.serverError));
    });
  });
}