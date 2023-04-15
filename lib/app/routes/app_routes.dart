// ignore_for_file: constant_identifier_names

part of "app_pages.dart";
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  // subroute not start & end with "/"
  static String HOME() => "/${_Path.HOME}";

  static String HOME_SEARCH() => "/${_Path.HOME}/${_Path.SEARCH}";
  static String HOME_DETAIL(int id) => "/${_Path.HOME}/${_Path.DETAIL}/$id";

  static String MOVIE(String slug) => "/${_Path.MOVIE}/$slug";
  static String MOVIE_DETAIL(String slug) => "${MOVIE(slug)}/${_Path.DETAIL}";
}

abstract class _Path {
  static const HOME = "home";
  static const DETAIL = "detail";
  static const ITEM = "item";
  static const SEARCH = "search";
  static const MOVIE = "movie";
}
