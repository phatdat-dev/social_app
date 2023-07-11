// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  Routes._();
  static String AUTHENTICATION() => _Paths.AUTHENTICATION;
  static String HOME() => _Paths.HOME;
  static String HOME_SEARCH() => _Paths.HOME + _Paths.SEARCH;
  static String MESSAGE() => _Paths.MESSAGE;
  static String MESSAGE_DETAIL(Object id) => _Paths.MESSAGE + _Paths.DETAIL + '/$id';
  static String MESSAGE_SEARCH() => _Paths.MESSAGE + _Paths.SEARCH;
  static String MESSAGE_SETTING_PROFILE(Object id) => _Paths.MESSAGE + _Paths.SETTING_PROFILE + '/$id';
  static String MESSAGE_SETTING_PROFILE_MEMBERS(Object id) => MESSAGE_SETTING_PROFILE(id) + _Paths.MEMBERS;
  static String OPENAI_MESSAGE() => _Paths.OPENAI + _Paths.MESSAGE;
  static String OPENAI_MESSAGE_SETTING() => OPENAI_MESSAGE() + _Paths.SETTING;
  static String GROUP(Object id) => _Paths.GROUP + '/$id';
  static String GROUP_CREATE() => _Paths.GROUP + _Paths.CREATE;
  static String GROUP_INFOMATION(Object id) => GROUP(id) + _Paths.INFOMATION;
  static String GROUP_INFOMATION_MEMBERS(Object id) => GROUP_INFOMATION(id) + _Paths.MEMBERS;
  static String GROUP_EDITING(Object id) => GROUP(id) + _Paths.EDITING;
  static String USER(Object id) => _Paths.USER + '/$id';
  static String USER_FRIEND(Object id) => USER(id) + _Paths.FRIEND;
  static String USER_PHOTO(Object id) => USER(id) + _Paths.PHOTOS;
  static String USER_PHOTO_ALBUM(Object id, String albumId) => USER_PHOTO(id) + _Paths.ALBUM + '/d/$albumId';
  static String USER_PHOTO_ALBUM_EDITING(Object id, String albumId) => USER_PHOTO_ALBUM(id, albumId) + _Paths.EDITING;
  static String USER_PHOTO_ALBUM_CREATE(Object id) => USER_PHOTO(id) + _Paths.ALBUM + _Paths.CREATE;
  static String USER_EDITING(Object id) => USER(id) + _Paths.EDITING;
  static String STORIES(Object id) => _Paths.STORIES + '/$id';
  static String POST(Object id) => _Paths.POST + '/$id';
  static String POST_CREATE() => _Paths.POST + _Paths.CREATE;
  static String POST_HISTORY(Object id) => POST(id) + _Paths.HISTORY;
  static String POST_REPORT(Object id) => POST(id) + _Paths.REPORT;
  static String NOTIFICATION() => _Paths.NOTIFICATION;
  static String VIDEO_CALL() => _Paths.VIDEO_CALL;
  static String VIDEO_CALL_DETAIL() => _Paths.VIDEO_CALL + _Paths.DETAIL;
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
  static const EDITING = '/editing';
  static const HISTORY = '/history';
  static const NOTIFICATION = '/notification';
  static const VIDEO_CALL = '/video-call';
  static const OPENAI = '/open-ai';
  static const SETTING = '/setting';
  static const PHOTOS = '/photos';
  static const ALBUM = '/album';
  static const REPORT = '/report';
}
