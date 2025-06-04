import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:manguinho/data/http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'http_adapter_test.mocks.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<Map?> request({
    required String url,
    required String method,
    Map? body
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    final response = await client.post(toUri(url), headers: headers, body: jsonBody);

    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Uri toUri(String url) => Uri.parse(url);
}

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
 
      expect(response, {"any_key": "any_value"});
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
  });
}