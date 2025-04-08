import 'package:http/http.dart' as http;

class Apiclient {
  final client="https://api.github.com/";

  final String endpoint;

  Apiclient(this.endpoint);

  Future<http.Response> getUser(username){
    // ignore: unnecessary_brace_in_string_interps
    return http.get('$client/users/${username}' as Uri);
  }


}