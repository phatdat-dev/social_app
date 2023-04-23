// ignore_for_file: non_constant_identifier_names

class ApiUrl {
  static String get get_base_url => 'https://animehay.live'; //baseUrl Image from crawl data
  static String get_fetchPost() => '/api/v1/fetch-post';
  static String post_auth_login() => '/api/auth/login';
  static String post_auth_forgotPassword() => '/api/auth/forgot-password';
  static String post_auth_register() => '/api/auth/register';
  static String get_fetchFriendByUserId(int userId, [int? limit]) =>
      limit != null ? '/api/v1/fetch-friend-by-user-id/$userId/$limit' : '/api/v1/fetch-friend-by-user-id/$userId';
}
