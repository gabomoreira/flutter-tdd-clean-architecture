import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'http_adapter_test.mocks.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request({
    required String url,
    required String method,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    await client.post(toUri(url), headers: headers);
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

    setUp(() {
      client = MockClient();
      sut = HttpAdapter(client);
      url = faker.internet.httpUrl();
      defaultHeaders = {
        'content-type': 'application/json',
        'accept': 'application/json'
      };
    });

    Uri mockedUri = sut.toUri(url);

    test('Should call post with correct values', () async {
      when(client.post(mockedUri, headers: defaultHeaders)) 
        .thenAnswer((_) async => Response('', 200));

      await sut.request(url: url, method: 'post');

      verify(client.post(
        mockedUri, 
        headers: defaultHeaders
      ));
    });
  });
}