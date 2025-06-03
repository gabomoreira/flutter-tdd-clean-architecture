import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:manguinho/data/http/http.dart';
import 'package:manguinho/data/usecases/usecases.dart';
import 'package:manguinho/domain/usecases/usecases.dart';
import 'package:manguinho/domain/helpers/helpers.dart';

import 'remote_authentication_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  late MockHttpClient httpClient;
  late String url;
  late RemoteAuthentication sut;

  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('Should call HttpClient with correct values', () async {
    when(httpClient.request(url: url, method: 'post')).thenAnswer((_) async => null);
    
    final params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
    await sut.auth(params);

    verify(httpClient.request(
      url: url,
      method: "post",
      body: {
        'email': params.email,
        'password': params.secret
      }
    ));
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    when(httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body')))
      .thenThrow(HttpError.badRequest);

    final params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
