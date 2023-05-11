// ignore_for_file: non_constant_identifier_names

class ApiUrl {
  static String get get_base_url => 'https://animehay.live'; //baseUrl Image from crawl data
  //auth
  static String post_auth_login() => '/api/auth/login';
  static String post_auth_forgotPassword() => '/api/auth/forgot-password';
  static String post_auth_register() => '/api/auth/register';
  //
  static String get_fetchPost() => '/api/v1/fetch-post';
  static String post_createPostt() => '/api/v1/create-post';
  static String get_fetchFriendByUserId(int userId, [int? limit]) =>
      limit != null ? '/api/v1/fetch-friend-by-user-id/$userId/$limit' : '/api/v1/fetch-friend-by-user-id/$userId';
  static String get_fetchGroupJoined() => '/api/v1/fetch-group-joined';
  static String get_fetchPostGroup() => '/api/v1/fetch-post-group';
  static String post_likePost() => '/api/v1/post/like-post';
  static String get_fetchPostByGroupId(int groupId) => '/api/v1/fetch-post-by-group-id/$groupId';
  static String get_fetchMemberGroup(int groupId) => '/api/v1/fetch-member-group/$groupId';
  static String post_removeMemberFromGroup() => '/api/v1/remove-member-from-group';
  static String post_removeAdminToGroup() => '/api/v1/remove-admin-to-group';
  static String post_addAdminToGroup() => '/api/v1/add-admin-group';
  static String post_saveDeviceToken() => '/api/v1/save-device-token';
  static String post_messageUploadFile() => '/api/v1/message/upload-file';
  static String post_sharePostToProfile() => '/api/v1/share-post-to-profile';
  static String post_fetchCommentByPost() => '/api/fetch-comment-by-post';
  static String post_createCommentPost() => '/api/v1/create-comment-post';
  static String post_replyComment() => '/api/v1/reply-comment';
}
