import '../../data/models/remote_account_model.dart';

import '../../domain/entities/entities.dart';
import '../../domain/helpers/domain_error.dart';
import '../../domain/usecases/usecases.dart';

import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<AccountEntity> auth(AuthenticationParams params) async {
    try {
      final body = RemoteAuthenticationParams.fromDomain(params);
      final response = await httpClient.request(url: url, method: 'post', body: body.toJson());  
      return RemoteAccountModel.fromJson(response).toEntity();
    } on HttpError catch(error) {
      throw error == HttpError.unauthorized ? DomainError.invalidCredentials : DomainError.unexpected;
    } 
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    required this.email,
    required this.password
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) => 
    RemoteAuthenticationParams(email: params.email, password: params.secret);

  Map toJson() => {'email': email, 'password': password};
}