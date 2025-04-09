import 'package:app/users_api.dart';

void handle_search_user(String username) async {
  final usersApi = UsersApi();

  // 1. Get specific user
  final user = await usersApi.getUserByUsername(username);
  print('User: $user');
}
