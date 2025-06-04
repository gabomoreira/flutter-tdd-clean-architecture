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
    return response.body.isEmpty ? null : jsonDecode(response.body);
  }

  Uri toUri(String url) => Uri.parse(url);
}

@GenerateMocks([Client])
void main() {
  
  group('post', () {
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

    test('Should call post with correct values', () async {
      final body = {'any_key': 'any_value'};
      when(client.post(mockedUri, headers: defaultHeaders, body: anyNamed('body'))) 
        .thenAnswer((_) async => Response('{"any_key": "any_value"}', 200));

      await sut.request(url: url, method: 'post');

      verify(client.post( 
        mockedUri, 
        headers: defaultHeaders,
      ));
    });

    test('Should call post with null body', () async {
      when(client.post(mockedUri, headers: defaultHeaders, body: anyNamed('body'))) 
        .thenAnswer((_) async => Response('{"any_key": "any_value"}', 200));

      await sut.request(url: url, method: 'post');

      verify(client.post( 
        any,
        headers: anyNamed('headers'),
      ));
    });

    test('Should return data with returns 200', () async {
      final body = {'any_key': 'any_value'};

      when(client.post(any, headers: anyNamed('headers'))) 
        .thenAnswer((_) async => Response('{"any_key": "any_value"}', 200));

      final response = await sut.request(url: url, method: 'post');

      expect(response, body);
    });

    test('Should return null if returns 200 no data', () async {
      when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body'))) 
        .thenAnswer((_) async => Response('', 200));

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });
  });
}