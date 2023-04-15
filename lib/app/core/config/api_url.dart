// ignore_for_file: non_constant_identifier_names

class ApiUrl {
  static String get get_base_url => "https://animehay.live"; //baseUrl Image from crawl data
  static String post_login() => "/api/Authentication/login";
  static String post_logout() => "/api/Authentication/logout"; //only web using cookie
  static String get_movie() => "/api/Movie";
  static String get_banner() => "/api/Banner";
}
