import 'api_client.dart';

class UsersApi {
  final Apiclient apiClient = Apiclient();

  /// Get a specific GitHub user by username
  Future<dynamic> getUserByUsername(String username) async {
    return await apiClient.get('users/$username');
  }

  /// Search users based on location and programming language
  Future<List<dynamic>?> searchUsers({required String location, required String language}) async {
    final query = 'location:$location language:$language';
    final response = await apiClient.get('search/users?q=${Uri.encodeComponent(query)}');

    if (response != null && response['items'] != null) {
      return response['items'];
    }

    return null;
  }
}
