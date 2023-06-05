// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  Routes._();
  static String AUTHENTICATION() => _Paths.AUTHENTICATION;
  static String HOME() => _Paths.HOME;
  static String MESSAGE() => _Paths.MESSAGE;
  static String MESSAGE_DETAIL(String id) => _Paths.MESSAGE + _Paths.DETAIL + '/$id';
  static String MESSAGE_SEARCH() => _Paths.MESSAGE + _Paths.SEARCH;
  static String MESSAGE_SETTING_PROFILE(String id) => _Paths.MESSAGE + _Paths.SETTING_PROFILE + '/$id';
  static String MESSAGE_SETTING_PROFILE_MEMBERS(String id) => MESSAGE_SETTING_PROFILE(id) + _Paths.MEMBERS;
  static String GROUP(String id) => _Paths.GROUP + '/$id';
  static String GROUP_INFOMATION(String id) => GROUP(id) + _Paths.INFOMATION;
  static String GROUP_INFOMATION_MEMBERS(String id) => GROUP_INFOMATION(id) + _Paths.MEMBERS;
  static String USER(String id) => _Paths.USER + '/$id';
  static String USER_FRIEND(String id) => USER(id) + _Paths.FRIEND;
  static String STORIES(String id) => _Paths.STORIES + '/$id';
  static String POST(String id) => _Paths.POST + '/$id';
  static String POST_CREATE() => _Paths.POST + _Paths.CREATE;
  static String POST_HISTORY(String id) => POST(id) + _Paths.HISTORY;
}

abstract class _Paths {
  _Paths._();
  static const AUTHENTICATION = '/authentication';
  static const HOME = '/home';
  static const MESSAGE = '/message';
  static const DETAIL = '/detail';
  static const SEARCH = '/search';
  static const SETTING_PROFILE = '/setting-profile';
  static const MEMBERS = '/members';
  static const GROUP = '/group';
  static const INFOMATION = '/infomation';
  static const USER = '/user';
  static const FRIEND = '/friend';
  static const STORIES = '/stories';
  static const POST = '/post';
  static const CREATE = '/create';
  static const HISTORY = '/history';
}
